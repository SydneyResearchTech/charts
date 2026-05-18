conf/generateConfiguration.py:
	curl -sSL \
		https://raw.githubusercontent.com/orthanc-server/orthanc-builder/refs/heads/master/docker/orthanc/generateConfiguration.py \
		-o conf/generateConfiguration.py
	sed -i '' 's|/run/secrets/|/.k8s/secrets/|g' conf/generateConfiguration.py
