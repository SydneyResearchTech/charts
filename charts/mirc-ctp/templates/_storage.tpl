{{/*
Returns storageClassName: value
*/}}
{{- define "mirc-ctp.storage.class" -}}
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
