{{/*
  https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING-URIS
  postgresql://user:password@host:port?sslmode=prefer
*/}}
{{- define "orthanc.postgresql.connectionuri" -}}
{{- print "postgresql://" }}
{{- print .Values.PostgreSQL.Username ":" .PGPASSWORD "@" }}
{{- print (include "orthanc.postgresql.host" .) }}
{{- print ":" .Values.PostgreSQL.Port "/" .Values.PostgreSQL.Database }}
{{- print "?sslmode=prefer" }}
{{- print "&connect_timeout=" .Values.PostgreSQL.ConnectionRetryInterval }}
{{- end }}

{{- define "orthanc.postgresql.host" -}}
{{- print .Values.PostgreSQL.Host | default (print (include "orthanc.fullname" .) "-postgresql") }}
{{- end }}

{{- define "orthanc.image" -}}
{{- if .Values.plugins.enabled }}
  {{- if .Values.plugins.python_enabled }}
    {{- printf "%s-python" .Values.image.repository -}}
  {{- else }}
    {{- printf "%s-plugins" .Values.image.repository -}}
  {{- end }}
{{- else }}
  {{- .Values.image.repository -}}
{{- end }}
{{- printf ":%s" (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "orthanc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "orthanc.fullname" -}}
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
{{- define "orthanc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "orthanc.labels" -}}
helm.sh/chart: {{ include "orthanc.chart" . }}
{{ include "orthanc.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "orthanc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "orthanc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "orthanc.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "orthanc.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
