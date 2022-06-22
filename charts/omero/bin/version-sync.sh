#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
SCRIPT_NAME="$(basename -- "${0}")"

SOURCE_CHART='Chart.yaml'
DEST_CHARTS=(
  charts/omero-server/Chart.yaml
)

VER=$(grep '^version:' $SCRIPT_DIR/../$SOURCE_CHART)
APPVER=$(grep '^appVersion:' $SCRIPT_DIR/../$SOURCE_CHART)

for CHART in "${DEST_CHARTS[@]}"; do
  sed -i '' \
    -e 's/^version:.*$/'"${VER}"'/' \
    -e 's/^appVersion:.*$/'"${APPVER}"'/' \
    $SCRIPT_DIR/../$CHART
done
