# charts/charts/nvflare/README.md

## Project deployment

Minimal example project deployment.

```yaml
---
# values.yaml
project:
  name: example-project
  admin: "project-admin@cluster.local"
  organisation: nvidia
dashboard:
  enabled: true
overseer:
  enabled: true
server:
  enabled: true
ingress:
  enabled: true
  className: "nginx"
  annotations:
    kubernetes.io/tls-acme: "true"
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - secretName: chart-example-tls
      hosts:
        - chart-example.local
```

```bash
helm repo add restek https://sydneyresearchtech.github.io/charts/
helm repo update
helm upgrade nvflare restek/nvflare -i -n nvflare --create-namespace -f values.yaml
```

## Site deployment

1. In the NVFlare dashboard associated to the project
   1. Create a user account
   2. Create a site
   3. *NB:* A project administrator will need to authorise the user account and site configuration
2. Download the sites startup kit and extract on your local system using the pin
3. Using the NVFlare Helm chart deploy a site resource
   * *NB:* The deployment will not finish until the startup secret has been created, outlined below
4. Set the environment variables outlined below to the required values
5. Create the startup secret to complete the Kubernetes deployment in step 3
6. To remain secure remove the extracted startup kit content from your system

Minimal example site Helm values file.

```yaml
---
# values.yaml
project:
  name: "example-project"
  organisation: "nvidia"
site:
  enabled: true
  name: "site-1"
  resources:
    limits:
      cpu: 100m
      memory: 128Mi
      nvidia.com/gpu: 1
  nodeSelector:
    kubernetes.io/arch: amd64
  tolerations:
    - key: nvidia.com/gpu
      operator: Exists
      effect: NoSchedule
```

Helm site deployment.

```bash
helm repo add restek https://sydneyresearchtech.github.io/charts/
helm repo update
helm upgrade nvflare restek/nvflare -i -n nvflare --create-namespace -f values.yaml
```

Startup kit Kubernetes secret.

```bash
HELM_RELEASE="nvflare"
NAMESPACE="nvflare"
STARTUP_KIT_PATH=""

SECRET_NAME="$HELM_RELEASE-site-startup"
STARTUP="$STARTUP_KIT_PATH/startup"

kubectl create secret generic $SECRET_NAME \
--namespace=$NAMESPACE \
--from-file=$STARTUP/client.crt \
--from-file=$STARTUP/client.key \
--from-file=$STARTUP/fed_client.json \
--from-file=$STARTUP/rootCA.pem \
--from-file=$STARTUP/signature.json \
--from-file=$STARTUP/start.sh \
--from-file=$STARTUP/stop_fl.sh \
--from-file=$STARTUP/sub_start.sh
```
