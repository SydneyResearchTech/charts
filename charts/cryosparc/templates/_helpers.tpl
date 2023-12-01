{{/*
*/}}
{{- define "cryosparc.storageClassName" -}}
{{- if or .vol.storageClassName .global.storageClassName -}}
{{- $storageClassName := (default .global.storageClassName .vol.storageClassName) -}}
{{- if eq $storageClassName "-" -}}
{{- printf "storageClassName: \"\"" }}
{{- else -}}
{{- printf "storageClassName: %s" $storageClassName }}
{{- end }}
{{- end }}
{{- end }}

{{/*
CryoSPARC Master API service name
http://{{ .Chart.Name }}-cryosparcm-command-core:39002/api
*/}}
{{- define "cryosparc.api" -}}
http://{{ .Chart.Name }}-cryosparcm:39002/api
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "cryosparc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cryosparc.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cryosparc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cryosparc.labels" -}}
helm.sh/chart: {{ include "cryosparc.chart" . }}
{{ include "cryosparc.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cryosparc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cryosparc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cryosparc.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cryosparc.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
