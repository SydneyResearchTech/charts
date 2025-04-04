{{- define "nvflare.site.fullname" -}}
{{- include "nvflare.fullname" . }}-site
{{- end }}

{{- define "nvflare.site.name" -}}
{{- include "nvflare.name" . }}-site
{{- end }}

{{- define "nvflare.site.labels" -}}
{{ include "nvflare.labels" . }}
sydney.edu.au/service: site
{{- end }}

{{- define "nvflare.site.selectorLabels" -}}
{{ include "nvflare.selectorLabels" . }}
sydney.edu.au/service: site
{{- end }}
