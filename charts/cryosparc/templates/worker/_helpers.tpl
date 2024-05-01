{{/*
Selector labels
*/}}
{{- define "cryosparc.w.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cryosparc.name" . }}w
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "cryosparc.w.cpus" -}}
{{ gt (int .) 0 |ternary . "" }}
{{- end }}

{{- define "cryosparc.w.ssd_quota" -}}
{{ gt (int .) 0 |ternary . "" }}
{{- end }}

{{- define "cryosparc.w.ssd_reserved" -}}
{{ gt (int .) 0 |ternary . "" }}
{{- end }}
