#!/usr/bin/env bash
#
PVs=( \
	cryosparc-ssd-2e5342e00d2b \
	cryosparc-projects \
	cryosparc-empiar-10025-subset \
)
for PV in "${PVs[@]}"; do
	PVC=$PV
	[[ $PV == cryosparc-ssd-2e5342e00d2b ]] && PVC='cryosparc-ssd'
	kubectl patch pv $PV -p '{"spec":{"claimRef": null}}'
	kubectl patch pv $PV -p '{"spec":{"claimRef":{"name": "'${PVC}'", "namespace": "default"}}}'
done

exit 0
