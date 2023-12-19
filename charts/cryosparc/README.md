# charts/cryosparc/README.md

## Minimum requirements

[To run the full test suit.](https://guide.cryosparc.com/setup-configuration-and-management/hardware-and-system-requirements)

* 4 cores CPU
* 64GB RAM
* 1x Nvidia GPU

## Deployment

```bash
kubectl exec -it deployment.apps/cryosparc -- mkdir -p /cryosparc_projects/data/EMPIAR/10025/data

kubectl cp ~/cryosparc/empiar_10025_subset.tar \
cryosparc-5d679f9d9f-grrlz:/cryosparc_projects/data/EMPIAR/10025/data/empiar_10025_subset.tar

kubectl exec -it deployment.apps/cryosparc -- \
tar xf /cryosparc_projects/data/EMPIAR/10025/data/empiar_10025_subset.tar -C/cryosparc_projects/data/EMPIAR/10025/data

helm test cryosparc

kubectl exec -it deployment.apps/cryosparc -- bash -c 'cryosparcm test install'
kubectl exec -it deployment.apps/cryosparc -- bash -c 'cryosparcm test workers P1 --test-tensorflow --test-pytorch'

kubectl exec -it deployment.apps/cryosparc -- bash -c 'ssh-keygen -f "/home/cryosparc/.ssh/authorized_keys" -R "[10.0.19.23]:2222"'
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

helm upgrade cryosparc ./ -i -f ./tmp/values.yaml

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
