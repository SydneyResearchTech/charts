{{- define "omero-web.runAsUser" -}}
{{- default (default "1000" .Values.podSecurityContext.runAsUser) .Values.securityContext.runAsUser }}
{{- end }}

{{- define "omero-web.securityContext" -}}
capabilities:
  drop: [ALL]
readOnlyRootFilesystem: true
runAsNonRoot: true
runAsUser: {{ include "omero-web.runAsUser" . }}
allowPrivilegeEscalation: false
{{- end }}

{{- define "omero-web.server_list" -}}
{{- if not .Values.omero.web.server_list }}
{{- printf "[[\"%s-omero-server\",4064,\"omero\"]]" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "omero-web.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "omero-web.fullname" -}}
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
{{- define "omero-web.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "omero-web.labels" -}}
helm.sh/chart: {{ include "omero-web.chart" . }}
{{ include "omero-web.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "omero-web.selectorLabels" -}}
app.kubernetes.io/name: {{ include "omero-web.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "omero-web.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "omero-web.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
