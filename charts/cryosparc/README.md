# charts/cryosparc/README.md

## Development

```bash
helm upgrade cryosparc ./ -i -f ./tmp/values.yaml
```

## Issues during development

```
Matplotlib created a temporary config/cache directory at /tmp/matplotlib-fqzxs9v9 because the default path (/cryosparc_master/.cache/matplotlib) is not a writable directory; it is highly recommended to set the MPLCONFIGDIR environment variable to a writable directory, in particular to speed up the import of Matplotlib and to better support multiprocessing.
```

## Notes

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
