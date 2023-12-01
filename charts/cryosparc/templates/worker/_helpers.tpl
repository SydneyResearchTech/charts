{{/*
Selector labels
*/}}
{{- define "cryosparc.w.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cryosparc.name" . }}w
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
