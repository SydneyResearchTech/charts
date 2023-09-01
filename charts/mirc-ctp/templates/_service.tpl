{{/*
Returns storageClassName: value
*/}}
{{- define "mirc-ctp.service.name" -}}
{{- $storageClass := .global.storageClass }}
{{- if .storage.storageClass }}
  {{- $storageClass = .storage.storageClass }}
{{- end }}
{{- if $storageClass }}
  {{- if eq "-" $storageClass }}
    {{- printf "storageClassName: \"\"" }}
  {{- else }}
    {{- printf "storageClassName: %s" $storageClass }}
  {{- end }}
{{- end }}
{{- end }}
