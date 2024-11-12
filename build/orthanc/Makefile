startup/generateConfiguration.py:
	curl -sSL https://raw.githubusercontent.com/orthanc-server/orthanc-builder/refs/heads/master/docker/orthanc/generateConfiguration.py -o startup/generateConfiguration.py
	sed -i '' -e 's/\r$$//' -e 's/ *$$//' startup/generateConfiguration.py
	sed -i '' 's|/run/secrets/\*.json|/.k8s/secrets/*.json|g' startup/generateConfiguration.py
