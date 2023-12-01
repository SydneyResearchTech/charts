#!/usr/bin/env bash
#
eval $(/cryosparc_master/bin/cryosparcm env)

[[ "$1" == *mongod ]] && \
	exec mongod $CRYOSPARC_DB_ENABLE_AUTH_FLAG \
		--dbpath "$CRYOSPARC_DB_PATH}" \
		--port $CRYOSPARC_MONGO_PORT \
		--oplogSize 64 \
		--replSet meteor $CRYOSPARC_MONGO_EXTRA_FLAGS \
		--wiredTigerCacheSizeGB $CRYOSPARC_MONGO_CACHE_GB \
		--bind_ip_all

if [[ "$1" == *cryosparcm ]] && [[ "$2" == start ]]; then
	[[ -z $CRYOSPARC_LICENSE_ID ]] && { >&2 echo "CRYOSPARC_LICENSE_ID not set"; exit 1; }
	$@
	exec tail -F -n1000 /cryosparc_master/run/supervisord.log
fi

exec $@
