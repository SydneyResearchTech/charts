{{- define "nvflare.server.overseer_endpoint" -}}
{{- if .Values.server.overseerEndpoint -}}
{{- .Values.server.overseerEndpoint }}
{{- else -}}
https://{{ include "nvflare.overseer.fullname" . }}:{{ .Values.overseer.service.port }}/api/v1
{{- end }}
{{- end }}

{{- define "nvflare.server.sp_endpoint" -}}
{{- printf "%s:$d:%d" (include "nvflare.server.service" .) .Values.server.service.fl.port .Values.server.service.admin.port }}
{{- end }}

{{- define "nvflare.server.service_target" -}}
{{- printf "%s:$d" (include "nvflare.server.service" .) .Values.server.service.fl.port }}
{{- end }}

{{- define "nvflare.server.service" -}}
{{- printf "%s.%s.svc.cluster.local" (include "nvflare.server.fullname" .) .Release.Namespace }}
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
