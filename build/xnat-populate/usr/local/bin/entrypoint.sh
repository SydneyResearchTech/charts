#!/bin/bash
CMD=''
if [ "$1" == "groovy" ]; then
	CMD="--user=$XNAT_USER --pass=$XNAT_PASSWORD"
	CMD="$CMD --url=$XNAT_URL"
	CMD="$CMD --data=$XNAT_DATA"
fi

set -x
exec "$@" $CMD
