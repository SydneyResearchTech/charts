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

cat <<EOT |kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: cryosparc-ssd-$UUID
spec:
  accessModes: [ReadWriteOnce]
  capacity:
    storage: 100Gi
  claimRef:
    name: cryosparc-ssd
    namespace: default
  local:
    path: /scratch/cryosparc-ssd-$UUID
  persistentVolumeReclaimPolicy: Delete
  storageClassName: local-storage
  volumeMode: Filesystem
EOT
```
