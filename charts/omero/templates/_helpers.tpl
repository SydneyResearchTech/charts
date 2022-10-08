{{- define "omero.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "omero.postgresql.database" -}}
omero
{{- end }}

{{- define "omero.postgresql.password" -}}
omero
{{- end }}

{{- define "omero.postgresql.port" -}}
5432
{{- end }}

{{- define "omero.postgresql.username" -}}
omero
{{- end }}
