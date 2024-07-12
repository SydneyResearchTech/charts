# charts/docs/snyk.md

## Snyk testing via `git commit`

Pre-requisites.

* [Install Snyk cli](https://docs.snyk.io/snyk-cli/install-or-update-the-snyk-cli)
* Snyk configuration for AU tenancy (if required)
  * `snyc config set endpoint https://app.au.snyk.io`
* Snyk authenticate
  * `snyk auth`

```bash
cd CHARTS_DIRECTORY

# Run all commit hooks including Snyk IaC tests
git commit

# Run Snyk agains individual chart e.g.,
./bin/snyk-iac-test charts/omero

# Run Snyk with configuration parameters
./bin/snyk-iac-test charts/omero --severity-threshold=high --json
```
