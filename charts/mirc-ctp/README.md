# charts/mirc-ctp

## Installation

```bash
helm repo add restek https://sydneyresearchtech.github.io/charts/

helm upgrade mirc-ctp restek/mirc-ctp -i -n mirc-ctp --create-namespace --values values.yaml
```

## Development

```bash
helm template mirc-ctp charts/mirc-ctp/ --values charts/mirc-ctp/tmp/values.yaml
helm upgrade mirc-ctp charts/mirc-ctp/ -i -n default --create-namespace --values charts/mirc-ctp/tmp/values.yaml
```
