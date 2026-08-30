#!/bin/sh

if [ "$1" == *"PopulateXnat.groovy" ]; then
	shift
	exec groovy PopulateXnat.groovy \
		--user=${XNAT_USER} \
		--pass=${XNAT_PASSWORD} \
		--url=${XNAT_URL} \
		--data=${XNAT_DATA} \
		"$@"
fi

exec "$@"
