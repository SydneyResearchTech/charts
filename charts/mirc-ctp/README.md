# charts/mirc-ctp

## Installation

```bash
helm repo add restek https://sydneyresearchtech.github.io/charts/

helm upgrade mirc-ctp restek/mirc-ctp -i -n mirc-ctp --create-namespace --values values.yaml
```

## X.509 SSL

Cert-manager X.509 certificate example. This example uses cert-manager operation to generate the Java p12 keystore.

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: mirc-ctp-keystore
  namespace: default
stringData:
  keystorePassword: XXXXXXXXXXXXXXXXXX
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: mirc-ctp-keystore
  namespace: default
spec:
  # Secret names are always required.
  secretName: mirc-ctp-keystore-tls

  # secretTemplate is optional. If set, these annotations and labels will be
  # copied to the Secret named example-com-tls. These labels and annotations will
  # be re-reconciled if the Certificate's secretTemplate changes. secretTemplate
  # is also enforced, so relevant label and annotation changes on the Secret by a
  # third party will be overwriten by cert-manager to match the secretTemplate.
  secretTemplate:
    annotations:
      my-secret-annotation-1: "foo"
      my-secret-annotation-2: "bar"
    labels:
      my-secret-label: foo

  duration: 2160h # 90d
  renewBefore: 360h # 15d
  subject:
    organizations:
      - The University of Sydney
  # The use of the common name field has been deprecated since 2000 and is
  # discouraged from being used.
  commonName: mirc-ctp.dev.sydney.edu.au
  isCA: false
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - server auth
    #- client auth
  # At least one of a DNS Name, URI, or IP address is required.
  dnsNames:
    - mirc-ctp.dev.sydney.edu.au
    - mirc-ctp.default.svc.cluster.local
    - mirc-ctp.default.svc
    - mirc-ctp.default
    - mirc-ctp
    - localhost
  #uris:
  #  - spiffe://cluster.local/ns/sandbox/sa/example
  #ipAddresses:
  #  - 192.168.0.5
  # Issuer references are always required.
  issuerRef:
    name: selfsigned-cluster-issuer
    # We can reference ClusterIssuers by changing the kind here.
    # The default value is Issuer (i.e. a locally namespaced Issuer)
    kind: ClusterIssuer
    # This is optional since cert-manager will default to this value however
    # if you are using an external issuer, change this to that issuer group.
    group: cert-manager.io
  keystores:
    pkcs12:
      create: true
      passwordSecretRef:
        name: "mirc-ctp-keystore"
        key: "keystorePassword"
```

## Development

```bash
helm template mirc-ctp charts/mirc-ctp/ --values charts/mirc-ctp/tmp/values.yaml
helm upgrade mirc-ctp charts/mirc-ctp/ -i -n default --create-namespace --values charts/mirc-ctp/tmp/values.yaml
```
