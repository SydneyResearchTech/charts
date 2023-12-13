#!/usr/bin/env bash
#
eval $(cryosparcw env)
[[ -z $CRYOSPARCW_SSHD_PORT ]] && CRYOSPARCW_SSHD_PORT="2222"

CMD=""
if [[ "$1" == *cryosparcw ]]; then
	CMD="/cryosparc_worker/bin/cryosparcw ${@:2}"
	if [[ "$2" == connect ]]; then
		[[ -z $CRYOSPARC_HOSTNAME ]] && CMD="$CMD --worker $(hostname -f)" || CMD="$CMD --worker $CRYOSPARC_HOSTNAME"
		CMD="$CMD --master $CRYOSPARC_MASTER --port $CRYOSPARC_PORT"
		[[ -z $CRYOSPARC_SSDPATH ]]  && CMD="$CMD --nossd" || CMD="$CMD --ssdpath $CRYOSPARC_SSDPATH"
		[[ -z $CRYOSPARC_UPDATE ]]     || CMD="$CMD --update"
		[[ -z $CRYOSPARC_SSHSTR ]]     || CMD="$CMD --sshstr $CRYOSPARC_SSHSTR"
		[[ -z $CRYOSPARC_CPUS ]]       || CMD="$CMD --cpus $CRYOSPARC_CPUS"
		[[ -z $CRYOSPARC_NOGPU ]]      || CMD="$CMD --nogpu"
		[[ -z $CRYOSPARC_GPUS ]]       || CMD="$CMD --gpus $CRYOSPARC_GPUS"
		[[ -z $CRYOSPARC_SSDQUOTA ]]   || CMD="$CMD --ssdquota $CRYOSPARC_SSDQUOTA"
		[[ -z $CRYOSPARC_SSDRESERVE ]] || CMD="$CMD --ssdreserve $CRYOSPARC_SSDRESERVE"
		[[ -z $CRYOSPARC_LANE ]]       || CMD="$CMD --lane $CRYOSPARC_LANE"
		[[ -z $CRYOSPARC_NEWLANE ]]    || CMD="$CMD --newlane"

                $CMD
		exec /usr/sbin/dropbear -R -F -E -m -s -j -k -p $CRYOSPARCW_SSHD_PORT
	fi
fi

exec $@
