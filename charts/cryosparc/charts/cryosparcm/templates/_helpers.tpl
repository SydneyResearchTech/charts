{{/*
CryoSPARC Master container volumes
*/}}
{{- define "cryosparcm.volumeMounts" -}}
- mountPath: /cryosparc_master/config.sh
  name: config-sh
  readOnly: true
  subPath: config.sh
- mountPath: /etc/passwd
  name: cryosparc-passwd
  readOnly: true
  subPath: passwd
- mountPath: /etc/group
  name: cryosparc-group
  readOnly: true
  subPath: group
{{- end }}
{{- define "cryosparcm.volumes" -}}
- name: config-sh
  secret:
    secretName: {{ include "cryosparcm.fullname" . }}
    items: [{key: config.sh, path: config.sh}]
- name: cryosparc-passwd
  configMap:
    name: {{ include "cryosparcm.fullname" . }}
    items: [{key: passwd, path: passwd}]
- name: cryosparc-group
  configMap:
    name: {{ include "cryosparcm.fullname" . }}
    items: [{key: group, path: group}]
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "cryosparcm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cryosparcm.fullname" -}}
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
{{- define "cryosparcm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cryosparcm.labels" -}}
helm.sh/chart: {{ include "cryosparcm.chart" . }}
{{ include "cryosparcm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cryosparcm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cryosparcm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cryosparcm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cryosparcm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
