#!/bin/bash -x
TAYGA='/usr/sbin/tayga'
IP='/usr/sbin/ip'
IPTABLES='/usr/sbin/iptables'

CONFIG='/etc/tayga.conf'
regex="--config[= ]([^ ]+)"
if [[ "$@" =~ $regex ]]; then
	CONFIG="${BASH_REMATCH[1]}"
fi

if [[ $1 == *"tayga" ]]; then
	shift
	TUN_DEVICE=$(sed -rn "/^[ \t]*tun-device/s/^[ \t]*tun-device[ \t]+//p" "$CONFIG")
	IPV6_PREFIX=$(sed -rn "/^[ \t]*prefix/s/^[ \t]*prefix[ \t]+//p" "$CONFIG")
	DYNAMIC_POOL=$(sed -rn "/^[ \t]*dynamic-pool/s/^[ \t]*dynamic-pool[ \t]+//p" "$CONFIG")

	$TAYGA --mktun --config=$CONFIG
	$IP link set $TUN_DEVICE up
	[ -n "$DYNAMIC_POOL" ]  && $IP route add "$DYNAMIC_POOL" dev "$TUN_DEVICE"
	[ -n "$IPV6_PREFIX" ]   && $IP route add "$IPV6_PREFIX" dev "$TUN_DEVICE"
	[ -n "$IPV4_TUN_ADDR" ] && $IP addr add "$IPV4_TUN_ADDR" dev "$TUN_DEVICE"
	[ -n "$IPV6_TUN_ADDR" ] && $IP addr add "$IPV6_TUN_ADDR" dev "$TUN_DEVICE"

	$IPTABLES -t nat -L POSTROUTING 2>/dev/null |grep -q "^MASQUERADE.*${DYNAMIC_POOL}" || \
		$IPTABLES -t nat -A POSTROUTING -s "$DYNAMIC_POOL" -j MASQUERADE

	exec $TAYGA --nodetach "$@"
fi

exec "$@"
