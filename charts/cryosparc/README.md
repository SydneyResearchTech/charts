# charts/cryosparc/README.md

## Deployment

```bash
mkdir -p /cryosparc_projects/data/EMPIAR/10025/data
kubectl cp ~/cryosparc/empiar_10025_subset.tar \
  cryosparc-5d679f9d9f-grrlz:/cryosparc_projects/data/EMPIAR/10025/data/empiar_10025_subset.tar
tar xf empiar_10025_subset.tar
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

```
Matplotlib created a temporary config/cache directory at /tmp/matplotlib-fqzxs9v9 because the default path (/cryosparc_master/.cache/matplotlib) is not a writable directory; it is highly recommended to set the MPLCONFIGDIR environment variable to a writable directory, in particular to speed up the import of Matplotlib and to better support multiprocessing.
```
