{{- define "omero.config" -}}
{{- $omero := .omero -}}
{{- $omero_cfg := .omero_cfg -}}
{{- if ne (kindOf $omero) "map" }}
  {{- printf "omero.%s=%s\n" (join "." $omero_cfg) ((trimAll "\"" (toJson $omero))|replace "\\\"" "\"") }}
{{- else }}
  {{- range $k, $v := $omero }}
    {{- include "omero.config" (dict "omero" $v "omero_cfg" (append $omero_cfg $k)) }}
  {{- end }}
{{- end }}
{{- end }}

# https://www.postgresql.org/docs/current/libpq-envars.html
#
{{- define "omero.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "omero.postgresql.postgresPassword" -}}
{{- .Values.global.postgresql.auth.postgresPassword|default .Values.global.postgresql.auth.password }}
{{- end }}

{{- define "omero.postgresql.database" -}}
{{- .Values.global.postgresql.auth.database|default "omero" }}
{{- end }}

{{- define "omero.postgresql.password" -}}
{{- .Values.global.postgresql.auth.password }}
{{- end }}

{{- define "omero.postgresql.port" -}}
{{- .Values.global.postgresql.service.ports.postgresql|default "5432"|quote }}
{{- end }}

{{- define "omero.postgresql.username" -}}
{{- .Values.global.postgresql.auth.username|default "omero" }}
{{- end }}

{{- define "omero.postgresql.pghost" -}}
{{- if and .Values.global.postgresql.existingConfigMap .Values.global.postgresql.configMapKeys.PGHOST -}}
valueFrom:
  configMapKeyRef:
    name: {{ .Values.global.postgresql.existingConfigMap }}
    key: {{ .Values.global.postgresql.configMapKeys.PGHOST }}
    optional: false
{{- else -}}
value: {{ .Values.global.postgresql.externalName | default (include "omero.postgresql.fullname" .) }}
{{- end }}
{{- end }}

{{- define "omero.postgresql.pgdatabase" -}}
{{- if and .Values.global.postgresql.existingConfigMap .Values.global.postgresql.configMapKeys.PGDATABASE -}}
valueFrom:
  configMapKeyRef:
    name: {{ .Values.global.postgresql.existingConfigMap }}
    key: {{ .Values.global.postgresql.configMapKeys.PGDATABASE }}
    optional: false
{{- else -}}
value: {{ .Values.global.postgresql.auth.database }}
{{- end }}
{{- end }}

{{- define "omero.postgresql.pgport" -}}
{{- if and .Values.global.postgresql.existingConfigMap .Values.global.postgresql.configMapKeys.PGPORT -}}
valueFrom:
  configMapKeyRef:
    name: {{ .Values.global.postgresql.existingConfigMap }}
    key: {{ .Values.global.postgresql.configMapKeys.PGPORT }}
    optional: false
{{- else -}}
value: {{ include "omero.postgresql.port" . }}
{{- end }}
{{- end }}

{{- define "omero.postgresql.pguser" -}}
{{- if and .Values.global.postgresql.existingConfigMap .Values.global.postgresql.configMapKeys.PGUSER -}}
valueFrom:
  configMapKeyRef:
    name: {{ .Values.global.postgresql.existingConfigMap }}
    key: {{ .Values.global.postgresql.configMapKeys.PGUSER }}
    optional: false
{{- else -}}
value: {{ include "omero.postgresql.username" . }}
{{- end }}
{{- end }}

{{- define "omero.postgresql.pgpassword" -}}
{{- if and .Values.global.postgresql.auth.existingSecret .Values.global.postgresql.auth.secretKeys.userPasswordKey -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.global.postgresql.auth.existingSecret }}
    key: {{ .Values.global.postgresql.auth.secretKeys.userPasswordKey }}
    optional: false
{{- else -}}
value: {{ include "omero.postgresql.password" . }}
{{- end }}
{{- end }}

{{- define "omero.postgresql.environmentVariables" -}}
- name: PGHOST
  {{- include "omero.postgresql.pghost" . | nindent 2 }}
- name: PGDATABASE
  {{- include "omero.postgresql.pgdatabase" . | nindent 2 }}
- name: PGPASSWORD
  {{- include "omero.postgresql.pgpassword" . | nindent 2 }}
- name: PGPORT
  {{- include "omero.postgresql.pgport" . | nindent 2 }}
- name: PGUSER
  {{- include "omero.postgresql.pguser" . | nindent 2 }}
- name: PG_COLOR
  value: never
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "omero.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "omero.fullname" -}}
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
{{- define "omero.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "omero.labels" -}}
helm.sh/chart: {{ include "omero.chart" . }}
{{ include "omero.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "omero.selectorLabels" -}}
app.kubernetes.io/name: {{ include "omero.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "omero.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "omero.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
