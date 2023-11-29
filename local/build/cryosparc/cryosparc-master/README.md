# build/cryosparc/cryosparc-master/README.md

## SSH key generation

```bash
TMPDIR=$(mktemp -d)

ssh-keygen -C 'cryosparc@master' -f ${TMPDIR}/id_ed25519 -N '' -t ed25519

kubectl create secret generic cryosparc-user \
--from-file=ssh-privatekey=${TMPDIR}/id_ed25519 \
--from-file=ssh-publickey=${TMPDIR}/id_ed25519.pub

rm -rf $TMPDIR
```

## Volumes
| Path | Description |
| ---- | ----------- |
| /cryosparc_master/run/ | log and pid files |
| /cryosparc_database/   | MongoDB files |
| /home/cryosparc/       | cryosparc user runtime files |

## Docker run

```bash
docker run -u 1001 --name cryosparcm --rm \
  localhost:32000/cryosparc-master:0.1.0
```

## Notes during development

Modified files and volumes

```
find / -mmin -5 >$(date '+%Y%m%d%H%M%S')
cryosparcm start

# cryospark user home
> /root
> /root/.config
> /root/.config/matplotlib
> /root/.cache
> /root/.cache/matplotlib
> /root/.cache/matplotlib/fontlist-v330.json

> /tmp
> /tmp/mongodb-39001.sock
> /tmp/cryosparc-supervisor-59c7deecdeb57cc87d609fb49d83266a.sock

> /cryosparc_database
> /cryosparc_database/storage.bson
> /cryosparc_database/index-51-6719505958770577848.wt
...
> /cryosparc_master/run
> /cryosparc_master/run/command_rtp.log
> /cryosparc_master/run/database.log
> /cryosparc_master/run/command_vis.log
> /cryosparc_master/run/vis
> /cryosparc_master/run/app_api.log
> /cryosparc_master/run/app.log
> /cryosparc_master/run/supervisord.log
> /cryosparc_master/run/supervisord.pid
> /cryosparc_master/run/command_core.log
```

```
cryosparcm start [<service name>]
app
app_api
app_legacy
command_core
command_rtp
command_vis
database

cryosparcm configuredb
```

Logs
```
command_core 
command_rtp
command_vis 
database 
app
app_legacy
app_api
```

## ISSUES

```
# cryosparcm start --systemd
Starting cryoSPARC System master process..
configuring database
    configuration complete
unix:///tmp/cryosparc-supervisor-59c7deecdeb57cc87d609fb49d83266a.sock no such file
```

```
# cryosparcm status
ERROR: Re-run this command on the master node: localhost.
Alternatively, set CRYOSPARC_FORCE_HOSTNAME=true in cryosparc_master/config.sh to suppress this error.
If this error message is incorrect, set CRYOSPARC_HOSTNAME_CHECK to the correct hostname in cryosparc_master/config.sh.
```
