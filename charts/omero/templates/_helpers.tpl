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
{{- .Values.global.postgresql.service.ports.postgresql|default "5432" }}
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
