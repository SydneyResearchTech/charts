# charts

```bash
helm repo add restek https://sydneyresearchtech.github.io/charts/

helm repo update

helm search repo restek

helm show values restek/omero
```

```bash
helm template omero charts/omero -f charts/omero/tmp/values.yaml
helm upgrade omero charts/omero -nomero --install --create-namespace --dependency-update --values ./charts/omero/tmp/values.yaml
```
