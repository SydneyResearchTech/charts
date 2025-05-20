{{/*
Expand bind9 executable options based on settings from the values file
*/}}
{{- define "bind.args" -}}
["-g","-p","dns=5353"
{{- if and (hasKey .Values "resources") (hasKey .Values.resources "limits") (hasKey .Values.resources.limits "cpu") -}}
,"-n","{{ .Values.resources.limits.cpu }}"
{{- end -}}
{{- if .Values.debug_level -}}
,"-d","{{ .Values.debug_level }}"
{{- end -}}
]
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "bind.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bind.fullname" -}}
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
{{- define "bind.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bind.labels" -}}
helm.sh/chart: {{ include "bind.chart" . }}
{{ include "bind.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bind.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bind.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bind.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bind.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
