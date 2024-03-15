#!/usr/bin/env python
import sys
import os
from cryosparc_compute import client

def main():
    project_container_dir = '/cryosparc_projects'
    project_title = 'Extensive Validation Testing'
    project_description = 'Validation testing for all CryoSPARC updates'
    workspace_title = 'Benchmark & Validation'

    host = os.environ['CRYOSPARC_MASTER_HOSTNAME']
    command_core_port = int(os.environ['CRYOSPARC_COMMAND_CORE_PORT'])
    command_rtp_port = int(os.environ['CRYOSPARC_COMMAND_RTP_PORT'])
    email_address = os.environ['CRYOSPARCM_UUID_EMAIL']

    cli = client.CommandClient(host=host, port=command_core_port)
    rtp = client.CommandClient(host=host, port=command_rtp_port)

    user_id = cli.get_id_by_email(email_address)
    project_uid = cli.create_empty_project(owner_user_id=user_id, project_container_dir=project_container_dir, title=project_title, desc=project_description)
    workspace_uid = cli.create_empty_workspace(project_uid=project_uid, created_by_user_id=user_id, title=workspace_title)
    return 0

if __name__ == '__main__':
    sys.exit(main())
