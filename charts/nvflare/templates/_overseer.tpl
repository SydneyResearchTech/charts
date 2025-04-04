{{- define "nvflare.overseer.fullname" -}}
{{- include "nvflare.fullname" . }}-overseer
{{- end }}

{{- define "nvflare.overseer.name" -}}
{{- include "nvflare.name" . }}-overseer
{{- end }}

{{- define "nvflare.overseer.labels" -}}
{{ include "nvflare.labels" . }}
sydney.edu.au/service: overseer
{{- end }}

{{- define "nvflare.overseer.selectorLabels" -}}
{{ include "nvflare.selectorLabels" . }}
sydney.edu.au/service: overseer
{{- end }}
