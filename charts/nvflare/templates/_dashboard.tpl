{{- define "nvflare.dashboard.storageClassName" -}}
{{- $storageClassName := (default .Values.global.storageClassName .Values.dashboard.persistence.storageClassName) -}}
{{- if $storageClassName -}}
  {{- if eq $storageClassName "-" -}}
    {{- printf "storageClassName: \"\"" }}
  {{- else }}
    {{- printf "storageClassName: $s" $storageClassName }}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "nvflare.dashboard.fullname" -}}
{{- include "nvflare.fullname" . }}-dashboard
{{- end }}

{{- define "nvflare.dashboard.name" -}}
{{- include "nvflare.name" . }}-dashboard
{{- end }}

{{- define "nvflare.dashboard.labels" -}}
{{ include "nvflare.labels" . }}
sydney.edu.au/service: dashboard
{{- end }}

{{- define "nvflare.dashboard.selectorLabels" -}}
{{ include "nvflare.selectorLabels" . }}
sydney.edu.au/service: dashboard
{{- end }}
