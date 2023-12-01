# docs/ssd_pvc.md

## Pre-req.

```bash
cat <<EOT |kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOT
```

## Persistent volume

```yaml
UUID=$(uuidgen |tr '[:upper:]' '[:lower:]'); UUID=${UUID##*-}; echo $UUID

sudo mkdir /scratch/cryosparc-ssd-$UUID

cat <<EOT |kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: cryosparc-ssd-$UUID
spec:
  accessModes: [ReadWriteOnce]
  capacity:
    storage: 1Gi
  claimRef:
    name: cryosparc-ssd
    namespace: default
  local:
    path: /scratch/cryosparc-ssd-$UUID
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  volumeMode: Filesystem
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - ip-10-0-19-23
EOT
```
