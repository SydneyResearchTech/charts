#!/usr/bin/env python3
# https://nvflare.readthedocs.io/en/2.4/user_guide/dashboard_api.html#api
import sys
import json
import os
import time
import requests
from kubernetes import client, config
from kubernetes.client.rest import ApiException
from io import BytesIO
import zipfile
import base64
from pprint import pprint

URL = "http://localhost:8443/api/v1"
HEADERS = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        }

def login():
    _credential = os.getenv('NVFL_CREDENTIAL')
    _email, _password = _credential.split(":", 1)

    r = requests.post(
            URL + "/login",
            headers=HEADERS,
            json = {
                "email": _email,
                "password": _password,
                },
            )
    if r.status_code != 200:
        raise Exception('login Response {0} {1}'.format(r.status_code, r.reason))
    HEADERS["Authorization"] = "Bearer " + r.json()["access_token"]

def createUser():
    _credential = os.getenv('NVFL_PROJ_ADMIN_CREDENTIAL')
    _email, _password = _credential.split(":", 1)
    _name, _org = _email.split("@", 1)
    try:
        r = requests.post(
                URL + "/users",
                headers = HEADERS,
                json = {
                    "email": _email,
                    "password": _password,
                    "name": _name,
                    "organization": _org,
                    "role": "project_admin",
                    "approval_state": 200,
                    },
                )
        if r.status_code not in [201, 409]:
            raise Exception('createUser Response {0} {1}'.format(r.status_code, r.reason))
    except Exception as e:
        print("ERROR {0}".format(e))

def readUsers():
    r = requests.get(
            URL + "/users",
            headers = HEADERS,
            )
    if r.status_code != 200:
        raise Exception('readUsers Response {0} {1}'.format(r.status_code, r.reason))
    return r.json()

def updateProject():
    r = requests.patch(
            URL + "/project",
            headers = HEADERS,
            json = {
                "app_location": "docker pull nvflare/nvflare:2.5.2",
                "short_name": "example-project",
                "overseer": "nvflare-overseer.nvflare.svc.cluster.local",
                "server1": "nvflare-server.nvflare.svc.cluster.local",
                "server2": "nvflare-server2.nvflare.svc.cluster.local",
                "ha_mode": True,
                },
            )
    if r.status_code != 200:
        raise Exception('updateProject Response {0} {1}'.format(r.status_code, r.reason))

# service = overseer, servers(id), client(id)
def readStartupKit(service, id=None):
    _pin = "qwerty"
    if id:
        _path = f'/{service}/{id}/blob'
    else:
        _path = f'/{service}/blob'

    r = requests.post(
            URL + _path,
            headers = HEADERS,
            json = {
                "pin": _pin,
                },
            )
    if r.status_code != 200:
        raise Exception('readStartupKit ({3}) Response {0} {1}'.format(r.status_code, r.reason, service))

    data = {}
    with zipfile.ZipFile(BytesIO(r.content), mode='r') as zf:
        zf.extractall(pwd=bytes(_pin,'utf-8'))
        for _name in zf.namelist():
            if _name.endswith(('.py','.crt','.key','.pem','.sh','.json')):
                _file = os.path.basename(_name)
                with zf.open(_name, pwd=bytes(_pin,'utf-8')) as f:
                    data[_file] = base64.b64encode(f.read()).decode('utf-8')
    return data

def createSecret(data, name):
    v1 = client.CoreV1Api()
    try:
        r = v1.create_namespaced_secret(
                namespace = os.getenv("K8S_NAMESPACE"),
                body = client.V1Secret(
                    api_version = "v1",
                    kind = "Secret",
                    metadata = client.V1ObjectMeta(
                        name = name,
                        namespace = os.getenv("K8S_NAMESPACE"),
                        ),
                    data = data,
                    ),
                )
    except ApiException as e:
        print("Exception when calling CoreV1Api->create_namespaced_secret: %s\n" % e)

def readProject():
    r = requests.get(
        URL + "/project",
        headers = HEADERS,
        )
    if r.status_code != 200:
        raise Exception('readProject Response {0} {1}'.format(r.status_code, r.reason))
    return r.json()["project"]

def readState():
    state = {
            "overseer": False,
            "servers": {
                "1": False,
                "2": False,
                },
            "clients": {},
            }
    try:
        with open('/dashboard/.ctrl_state', 'r') as f:
            state = json.load(f)
    except Exception as e:
        print(f'readState {e}')
    return state

def updateState(state):
    try:
        with open('/dashboard/.ctrl_state', 'w') as f:
            json.dump(state, f)
    except Exception as e:
        print(f'updateState {e}')

def main():
    config.load_incluster_config()
    state = readState()

    while True:
        try:
            if "Authorization" not in HEADERS:
                login()
            createUser()

            project = readProject()
            if project["frozen"]:
                if project["ha_mode"]:
                    if not state['overseer']:
                        data = readStartupKit("overseer")
                        createSecret(data, os.getenv("NVFL_OVERSEER_SECRET"))
                        state['overseer'] = True
                    if not state['servers']['2']:
                        data = readStartupKit("servers", 2)
                        createSecret(data, "{0}-2".format(os.getenv("NVFL_SERVER_SECRET")))
                        state['servers']['2'] = True

                if not state['servers']['1']:
                    data = readStartupKit("servers", 1)
                    createSecret(data, "{0}-1".format(os.getenv("NVFL_SERVER_SECRET")))
                    state['servers']['1'] = True
            else:
                updateProject()

            updateState(state)
        except Exception as e:
            print("ERROR {0}".format(e))

        time.sleep(15)

if __name__ == '__main__':
    sys.exit(main())
