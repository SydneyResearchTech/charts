# test-gpu.md

```bash
kubectl logs -n gpu-operator-resources -lapp=nvidia-operator-validator -c nvidia-operator-validator

kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: cuda-vector-add
spec:
  restartPolicy: OnFailure
  containers:
    - name: cuda-vector-add
      image: "k8s.gcr.io/cuda-vector-add:v0.1"
      resources:
        limits:
          nvidia.com/gpu: 1
  nodeName: hades
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: cuda-ubuntu
spec:
  restartPolicy: OnFailure
  containers:
    - name: cuda-vector-add
      image: "nvidia/cuda:12.2.2-base-ubuntu22.04"
      command: [tail, -f, /dev/null]
      resources:
        limits:
          nvidia.com/gpu: 1
EOF
```
