#!/bin/sh
if [ -f "${FED_SERVER_JSON}" ]; then
	envsubst <"${FED_SERVER_JSON}" >"${FED_SERVER_JSON}"
fi
