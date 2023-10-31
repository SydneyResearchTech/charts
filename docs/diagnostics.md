# charts/docs/diagnostics.md

## Network

### IPerf3

Authentication - RSA Keypair

```bash
TDIR=$(mktemp -d)

openssl genrsa -des3 -out ${TDIR}/private.pem 2048
openssl rsa -in ${TDIR}/private.pem -outform PEM -pubout -out ${TDIR}/public.pem
openssl rsa -in ${TDIR}/private.pem -out ${TDIR}/private_not_protected.pem -outform PEM

kubectl create secret tls iperf3-tls \
--cert=${TDIR}/public.pem \
--key=${TDIR}/private_not_protected.pem

rm -fr "${TDIR}" 
```

Authentication - Authorized users configuration file

```bash
PASSWORD=$(uuidgen)

kubectl create secret generic iperf3-auth \
--from-literal=iperf3-client=$(echo -n "iperf3-client${PASSWORD}" |sha256sum |awk '{print $1}')
```

Create server deployment and service

```bash
IPERF_PORT="5201"

cat <<EOT |kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iperf3-server
  labels:
    app.kubernetes.io/name: iperf3-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: iperf3-server
  template:
    metadata:
      labels:
        app.kubernetes.io/name: iperf3-server
    spec:
      containers:
      - name: iperf3-server
        image: ghcr.io/sydneyresearchtech/diagnostics:0.1.0
        env:
        - {name: IPERF_PORT, value: "${IPERF_PORT}"}
        command: ["iperf3"]
        args:
        - -p $IPERF_PORT
        - --server
        - --debug
        ports:
        - containerPort: $IPERF_PORT
---
apiVersion: v1
kind: Service
metadata:
  name: iperf3-server
  annotations: {}
  #  service.beta.kubernetes.io/load-balancer-source-ranges: 129.78.0.0/16,203.32.106.0/24,203.32.107.0/24,220.235.127.71/32
spec:
  selector:
    app.kubernetes.io/name: iperf3-server
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: $IPERF_PORT
      targetPort: $IPERF_PORT
  loadBalancerSourceRanges:
  - 129.78.0.0/16
  - 203.32.106.0/24
  - 203.32.107.0/24
  - 220.235.127.71/32
EOT


# View server logs
kubectl logs deployment.apps/iperf3-server

# Cleanup
kubectl delete deployment.apps/iperf3-server
kubectl delete service/iperf3-server

# Create IPerf3 client deployment

cat <<EOT |kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iperf3-client
  labels:
    app: iperf3-client
spec:
  replicas: 1
  selector:
    matchLabels:
      app: iperf3-client
  template:
    metadata:
      labels:
        app: iperf3-client
    spec:
      containers:
      - name: iperf3-client
        image: ghcr.io/sydneyresearchtech/diagnostics:0.1.0
        env:
        - {name: IPERF_SERVER, value: iperf3-server}
        command: ["iperf3"]
        args:
        - --client $IPERF_SERVER
        - --zerocopy
        - --username iperf3-client
        - --rsa-public-key-path ""
EOT
```
