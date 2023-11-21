# charts/cryosparc/README.md

## Development

```bash
helm upgrade cryosparc cryosparc/ -i -f tmp/cryosparc.yaml
```

## Issues during development

```
Matplotlib created a temporary config/cache directory at /tmp/matplotlib-fqzxs9v9 because the default path (/cryosparc_master/.cache/matplotlib) is not a writable directory; it is highly recommended to set the MPLCONFIGDIR environment variable to a writable directory, in particular to speed up the import of Matplotlib and to better support multiprocessing.
```
