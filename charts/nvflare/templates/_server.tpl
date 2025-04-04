{{- define "nvflare.server.overseer_endpoint" -}}
{{- if .Values.server.overseerEndpoint -}}
{{- .Values.server.overseerEndpoint }}
{{- else -}}
https://{{ include "nvflare.overseer.fullname" . }}:{{ .Values.overseer.service.port }}/api/v1
{{- end }}
{{- end }}

{{- define "nvflare.server.fullname" -}}
{{- include "nvflare.fullname" . }}-server
{{- end }}

{{- define "nvflare.server.name" -}}
{{- include "nvflare.name" . }}-server
{{- end }}

{{- define "nvflare.server.labels" -}}
{{ include "nvflare.labels" . }}
sydney.edu.au/service: server
{{- end }}

{{- define "nvflare.server.selectorLabels" -}}
{{ include "nvflare.selectorLabels" . }}
sydney.edu.au/service: server
{{- end }}
