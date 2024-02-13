#!/usr/bin/env bash
# local-storage.sh >tmp/local-storage.yaml
# kubectl apply -f ./tmp/local-storage.yaml
#
PVs=( empiar-10025-subset projects )
NAMESPACE='default'
HELM_NAME='cryosparc'
WD="/vol/efs/${HELM_NAME}"

HOST_IP=$(ip route get 1 |awk '{print $(NF-2);exit}')
HOSTNAME=$(hostname)
UUID=$(uuidgen |tr '[:upper:]' '[:lower:]'); UUID=${UUID##*-}

for PV in "${PVs[@]}"; do
	sudo mkdir -p "${WD}/${PV}"
	sudo chmod 1777 "${WD}/${PV}"

#	cat <<EOT |kubectl apply -f -
	cat <<EOT
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${HELM_NAME}-${PV}
spec:
  accessModes: [ReadWriteOnce]
  capacity:
    storage: 1Gi
  claimRef:
    name: ${HELM_NAME}-${PV}
    namespace: default
  local:
    path: ${WD}/${PV}
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
          - $HOSTNAME
EOT
done
