#!/bin/sh
if [ "$1" == "unfsd" ]; then
	rpcbind
	until rpcinfo -p &>/dev/null; do
		sleep 1
	done
	rpc.statd -p 662
fi
echo "$@"
exec "$@"
