# charts/cryosparc/README.md

| Key | Type | Default | Description |
| --- | ---- | ------- | ----------- |

## Setup

The CryoSPARC Helm template has been developed to allow a flexible deployment methodology.
Within the University of Sydney there are several deployment use cases, however this can be too cumbersome to document.
Below are the primary use cases with configuration snippets.

1. Ephemeral CryoSPARC cluster.
   Short lived cluster for specific purpose, short project, testing, development, etc...
2. Long operational cluster.
   Consistent usage and long lived deployment with site administration, application life cycle management, etc...
   *NB:* Make sure to read the section on `Reserving a PersistentVolume`. This will be very important if for any reason the
   persistent volume claim (PVC) is deleted and you need to re-bind the existing persistent volume (PV) to your new deployment.
3. Edge compute, pre-processing, CryoSPARC Live
4. Compute host dedicated to CryoSPARC.
   A one-to-one mapping of CryoSPARC worker node to compute host. Dedicated use of GPU(s).
5. GPU(s) are shared, host is configured for Multi-Instance GPU (MIG), etc...

## 2. Long operational cluster

Recommendations:
* Manually create persistent volume claims and reserve for specific purpose.
  This provides a more stable volume mapping in cases where persistent volume claims (PVCs) could be deleted,
  such as a full helm redeployment.

```bash
# List available storage classes
kubectl get sc

# EDIT AS REQUIRED; Deploy PVC(s)
cat <<EOT |kubectl apply -f -
---
# Create volume for testing data
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cryosparc-empiar-10025-subset
  namespace: cryosparc
spec:
  accessModes: [ReadWriteMany]
  resources:
    requests:
      storage: 1Gi
  storageClassName: nfs
  volumeMode: Filesystem
---
# Create default projects volume
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cryosparc-projects
  namespace: cryosparc
spec:
  accessModes: [ReadWriteMany]
  resources:
    requests:
      storage: 1Gi
  storageClassName: nfs
  volumeMode: Filesystem
EOT
```

* Configuration snippets for Helm deployment values.

```yaml
volumes:
- name: projects
  accessModes: [ReadWriteMany]
  path: /cryosparc_projects
  persistenVolumeClaimName: "cryosparc-projects"
  size: 1Gi
  storageClassName: ""
- name: empiar-10025-subset
  accessModes: [ReadWriteMany]
  path: /bulk5/data/EMPIAR/10025/data
  persistenVolumeClaimName: "cryosparc-projects"
  size: 1Gi
  storageClassName: ""
```

## Reserving a PersistentVolume

```bash
PV=pvc-448c244a-2460-4564-9bb8-36028098c866

kubectl patch pv $PV --type json -p '[{"op": "remove", "path": "/spec/claimRef"}]'

kubectl patch pv $PV --type json -p '[{"op": "replace", "path": "/spec/claimRef", "value": {"name": "cryosparc-projects", "namespace": "cryosparc"}}]'


cat <<EOT |kubectl apply -f -
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: cryosparc-mongodb
spec:
  accessModes: [ReadWriteOnce]
  capacity:
    storage: 10Gi
  claimRef:
    name: cryosparc-mongodb-cryosparc-0
    namespace: cryosparc
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: "manual"
  volumeMode: Filesystem
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: cryosparc-projects
spec:
  storageClassName: ""
  claimRef:
    name: cryosparc-projects
    namespace: cryosparc
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: cryosparc-empiar-10025-subset
spec:
  storageClassName: ""
  claimRef:
    name: cryosparc-empiar-10025-subset
    namespace: cryosparc
EOT
```

## Minimum requirements

[To run the full test suit.](https://guide.cryosparc.com/setup-configuration-and-management/hardware-and-system-requirements)

* 4 cores CPU
* 64GB RAM
* 1x Nvidia GPU

## Deployment

NVIDIA examples

```bash
kubectl get node ip-10-0-19-23 -o=jsonpath='{.metadata.labels}' \
 |jq '.|with_entries(select(.key|startswith("nvidia")))'
```

```json
{
  "nvidia.com/cuda.driver.major": "545",
  "nvidia.com/cuda.driver.minor": "23",
  "nvidia.com/cuda.driver.rev": "08",
  "nvidia.com/cuda.runtime.major": "12",
  "nvidia.com/cuda.runtime.minor": "3",
  "nvidia.com/gfd.timestamp": "1710736196",
  "nvidia.com/gpu.compute.major": "7",
  "nvidia.com/gpu.compute.minor": "5",
  "nvidia.com/gpu.count": "1",
  "nvidia.com/gpu.deploy.container-toolkit": "true",
  "nvidia.com/gpu.deploy.dcgm": "true",
  "nvidia.com/gpu.deploy.dcgm-exporter": "true",
  "nvidia.com/gpu.deploy.device-plugin": "true",
  "nvidia.com/gpu.deploy.driver": "true",
  "nvidia.com/gpu.deploy.gpu-feature-discovery": "true",
  "nvidia.com/gpu.deploy.node-status-exporter": "true",
  "nvidia.com/gpu.deploy.operator-validator": "true",
  "nvidia.com/gpu.family": "turing",
  "nvidia.com/gpu.machine": "g4dn.4xlarge",
  "nvidia.com/gpu.memory": "15360",
  "nvidia.com/gpu.present": "true",
  "nvidia.com/gpu.product": "Tesla-T4",
  "nvidia.com/gpu.replicas": "1",
  "nvidia.com/mig.capable": "false",
  "nvidia.com/mig.strategy": "single"
}
```

```bash
kubectl exec -it deployment.apps/cryosparc -- mkdir -p /cryosparc_projects/data/EMPIAR/10025/data

POD=$(kubectl get pod -l app.kubernetes.io/name=cryosparc -o jsonpath="{.items[0].metadata.name}")

kubectl cp ~/cryosparc/empiar_10025_subset.tar \
$POD:/cryosparc_projects/data/EMPIAR/10025/data/empiar_10025_subset.tar

kubectl exec -it deployment.apps/cryosparc -- \
tar xf /cryosparc_projects/data/EMPIAR/10025/data/empiar_10025_subset.tar -C/cryosparc_projects/data/EMPIAR/10025/data

helm test cryosparc

kubectl exec -it deployment.apps/cryosparc -- bash -c 'cryosparcm test install'
kubectl exec -it deployment.apps/cryosparc -- bash -c 'cryosparcm test workers P1 --test-tensorflow --test-pytorch'

kubectl exec -it deployment.apps/cryosparc -- bash -c 'ssh-keygen -f "/home/cryosparc/.ssh/authorized_keys" -R "[10.0.19.23]:2222"'
```

```
kubectl get pod -l app.kubernetes.io/name=cryosparc -o jsonpath="{.items[0].spec.containers[*].name}"
kubectl get pod -l app.kubernetes.io/name=cryosparc -o jsonpath="{.items[0].spec.containers[*].name}" |grep -o '\blog-[a-z-]*' \
| xargs -n1 kubectl logs --tail=20 deployment.apps/cryosparc -c
```

## Operations

### Maintenance mode

* cryosparcm cli "get_scheduler_targets()" | tee cryosparc_targets_$(date +%s).out
  * cryosparcm cli remove_scheduler_target_node('worker_name')
  * https://discuss.cryosparc.com/t/maintenance-mode-for-worker-nodes/10624
* kubectl create job --from=cronjob/<name of cronjob> <name of job>

## Extensive Validation

```
/bulk5/data/EMPIAR/10025/data/empiar_10025_subset
```

```
/bulk9/data/EMPIAR/10305/data/empiar_10305
```

## User management

```csv
email,password,admin,username,firstname,lastname
user1@sydney.edu.au,,,True,User,One
user2@sydney.edu.au,,,False,User,Two
```

* First line must be exact titles provided
* email (mandatory), must be a legitimate email format name@domain.local
* password, default is a random password for security and a password reset token will be generated for the account
* admin (False|True), default False. Grant this account Admin rights?
* username, default is accounts email

## Development

```bash
./bin/create-ssh-secret

helm upgrade cryosparc ./ -i -f ./tmp/values.yaml --wait

kubectl exec deployment.apps/cryosparc -- bash -c '/cryosparc_master/bin/cryosparcm createuser --email "dean.taylor@sydney.edu.au" --username "dean.taylor@sydney.edu.au" --firstname "Dean" --lastname "Taylor" --password "password"'

kubectl patch pv cryosparc-ssd-2e5342e00d2b -p '{"spec":{"claimRef": null}}'
```

## Notes

* PodInitializing can take everal minutes due to the size of the CryoSPARC base images.

```
$ cryosparcm listusers                                                                                                                    
| Name                    | Email                             | Admin    | ID                            |
----------------------------------------------------------------------------------------------------------

```

```
$ cryosparcm createuser --email "dean.taylor@sydney.edu.eu" --username "dean.taylor@sydney.edu.au" --firstname "Dean" --lastname "Taylor" --password "password"
Creating user dean.taylor@sydney.edu.au with email: dean.taylor@sydney.edu.eu and name: Dean Taylor
Successfully created user account.
```

```
$ cryosparcm listusers
| Name                    | Email                             | Admin    | ID                            |
----------------------------------------------------------------------------------------------------------
| dean.taylor@sydney.edu.au| dean.taylor@sydney.edu.eu         | True     | 65656bd3cb842e074fbae2e8      |

```

```
$ cryosparcm listusers |sed -e '1,2d' -e 's/\s//g' -e '/^\s*$/d'
|dean.taylor@sydney.edu.au|dean.taylor@sydney.edu.eu|True|65656bd3cb842e074fbae2e8|
|user@sydney.edu.au|user@sydney.edu.eu|False|65656c77cb842e074fbae2e9|
```

## Issues during development

ISSUE

```
Error occurred while processing J2/imported/001859056999465424869_14sep05c_00024sq_00003hl_00002es.frames.tif
Traceback (most recent call last):
  File "/cryosparc_worker/cryosparc_compute/jobs/pipeline.py", line 61, in exec
    return self.process(item)
  File "cryosparc_master/cryosparc_compute/jobs/motioncorrection/run_patch.py", line 132, in cryosparc_master.cryosparc_compute.jobs.motioncorrection.run_patch.run_patch_motion_correction_multi.motionworker.process
  File "cryosparc_master/cryosparc_compute/jobs/motioncorrection/run_patch.py", line 147, in cryosparc_master.cryosparc_compute.jobs.motioncorrection.run_patch.run_patch_motion_correction_multi.motionworker.process
  File "cryosparc_master/cryosparc_compute/blobio/prefetch.py", line 70, in cryosparc_master.cryosparc_compute.blobio.prefetch.synchronous_native_read
OSError:
 
IO request details:
Error ocurred (Input/output error) at line 849 in sendfile
 
filename:    /cryosparc_projects/CS-extensive-validation-testing/J2/imported/001859056999465424869_14sep05c_00024sq_00003hl_00002es.frames.tif
filetype:    1
header_only: 0
idx_start:   0
idx_limit:   -1
eer_upsampfactor: 1
eer_numfractions: 40
num_threads: 6
buffer:      (nil)
buffer_sz:   0
nx, ny, nz:  0 0 0
dtype:       0
total_time:  -1.000000
io_time:     0.033112
 
 
Marking J2/imported/001859056999465424869_14sep05c_00024sq_00003hl_00002es.frames.tif as incomplete and continuing...
```

Ref.
* https://discuss.cryosparc.com/t/runtimeerror-sendfile582-input-output-error/10243
* https://discuss.cryosparc.com/t/patch-motion-correction-error-v4-2-0/11096

Workaround

```
export CRYOSPARC_TIFF_IO_SHM=false
```

```
Matplotlib created a temporary config/cache directory at /tmp/matplotlib-fqzxs9v9 because the default path (/cryosparc_master/.cache/matplotlib) is not a writable directory; it is highly recommended to set the MPLCONFIGDIR environment variable to a writable directory, in particular to speed up the import of Matplotlib and to better support multiprocessing.
```
