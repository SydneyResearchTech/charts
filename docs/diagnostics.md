# charts/docs/diagnostics.md

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
spec:
  selector:
    app.kubernetes.io/name: iperf3-server
  type: LoadBalancer
  ports:
    - protocol: TCP
      port: $IPERF_PORT
      targetPort: $IPERF_PORT
EOT

kubectl logs deployment.apps/iperf3-server

kubectl port-forward service/iperf3-server 5201:5201
kubectl port-forward pod/iperf3-server-69d6b48fff-kk472 5201:5201

kubectl delete deployment.apps/iperf3-server
kubectl delete service/iperf3-server

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
        - --connect-timeout 600
        - --zerocopy
        - --debug
EOT
```
