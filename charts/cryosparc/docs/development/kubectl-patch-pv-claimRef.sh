#!/usr/bin/env bash
#
PVs=( \
	cryosparc-ssd-2e5342e00d2b \
	cryosparc-projects \
	cryosparc-empiar-10025-subset \
)
for pv in "${PVs[@]}"; do
kubectl patch pv $pv -p '{"spec":{"claimRef": null}}'
done
