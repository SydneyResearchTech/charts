{{/*
*/}}
{{- define "cryosparc.master.service" -}}
{{- end }}

{{- define "cryosparc.master.isready" -}}
$(curl -s -o /dev/null -w "%{http_code}" http://{{ include "cryosparc.fullname" . }}m:39002/) == '200'
{{- end }}

{{/*
CryoSPARC common container volumes
*/}}
{{- define "cryosparc.volumeMounts" -}}
- mountPath: /etc/passwd
  name: cryosparc-passwd
  readOnly: true
  subPath: passwd
- mountPath: /etc/group
  name: cryosparc-group
  readOnly: true
  subPath: group
- mountPath: /home
  name: cryosparc-home
{{- end }}

{{- define "cryosparc.volumes" -}}
- name: cryosparc-group
  configMap:
    name: {{ include "cryosparc.fullname" . }}
    items: [{key: group, path: group}]
- name: cryosparc-home
  emptyDir:
    sizeLimit: 500Mi
{{- end }}

{{- define "cryosparc.master.volumeMounts" -}}
{{ include "cryosparc.volumeMounts" . }}
- mountPath: /cryosparc_master/config.sh
  name: cryosparc-config
  readOnly: true
  subPath: config.sh
{{- end }}

{{- define "cryosparc.master.volumes" -}}
- name: cryosparc-passwd
  configMap:
    name: {{ include "cryosparc.fullname" . }}
    items: [{key: passwd, path: passwd}]
{{ include "cryosparc.volumes" . }}
- name: cryosparc-config
  secret:
    secretName: {{ include "cryosparc.fullname" . }}
    items:
      - key: config.sh
        path: config.sh
{{- end }}

{{- define "cryosparc.worker.volumeMounts" -}}
{{ include "cryosparc.volumeMounts" . }}
- mountPath: /cryosparc_worker/config.sh
  name: cryosparc-config
  readOnly: true
  subPath: config.sh
{{- end }}

{{- define "cryosparc.worker.volumes" -}}
- name: cryosparc-passwd
  configMap:
    name: {{ include "cryosparc.fullname" . }}w
    items: [{key: passwd, path: passwd}]
{{ include "cryosparc.volumes" . }}
- name: cryosparc-config
  secret:
    secretName: {{ include "cryosparc.fullname" . }}w
    items:
      - key: config.sh
        path: config.sh
{{- end }}

{{/*
CryoSPARC Master container volumes
*/}}
{{- define "cryosparc.master.volumeMounts.decomm" -}}
- mountPath: /cryosparc_master/config.sh
  name: config-sh
  readOnly: true
  subPath: config.sh
{{ include "cryosparc.volumeMounts" . }}
{{- end }}
{{- define "cryosparc.master.volumes.decomm" -}}
- name: config-sh
  secret:
    secretName: {{ include "cryosparc.fullname" . }}
    items: [{key: config.sh, path: config.sh}]
{{ include "cryosparc.volumes" . }}
{{- end }}

{{/*
storageClassName key value helper
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
http://{{ include "cryosparc.fullname" . }}:39002/api
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
