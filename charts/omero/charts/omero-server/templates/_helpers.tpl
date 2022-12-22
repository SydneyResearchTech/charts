# omero/charts/omero-server/templates/_helpers.tpl
#
{{- define "omero-server.conf" }}
{{- $dictIn := . }}
{{- range (keys $dictIn |sortAlpha) }}
{{- if kindIs "map" (get $dictIn .) }}
{{- get $dictIn . |include "omero-server.conf" }}
{{- else }}
{{- printf "%s=%s" . (toJson (get $dictIn .)) }}
{{ end }}
{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "omero-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "omero-server.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "omero-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "omero-server.labels" -}}
helm.sh/chart: {{ include "omero-server.chart" . }}
{{ include "omero-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "omero-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "omero-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "omero-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "omero-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create OMERO default root password
*/}}
{{- define "omero-server.defaultRootPassword" }}
{{- default (randAlphaNum 32) .Values.omero.root_pass }}
{{- end }}

# https://docs.python.org/3/library/tempfile.html
# https://docs.python.org/3/using/cmdline.html
# https://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html
# https://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html
{{- define "omero-server.environmentVariables" -}}
- {name: OMERODIR, value: {{ .Values.omeroDir |quote }}}
- {name: HOME, value: {{ .Values.omeroTmpDir |quote }}}
- {name: TMPDIR, value: {{ .Values.omeroTmpDir |quote }}}
- {name: OMERO_TMPDIR, value: {{ .Values.omeroTmpDir |quote }}}
- {name: _JAVA_OPTIONS, value: "-Djava.io.tmpdir={{ .Values.omeroTmpDir }}"}
{{- end }}
{{- define "omero-server.volumeMounts" -}}
- mountPath: {{ .Values.omeroTmpDir |quote }}
  name: omero-temp-dir
{{- end }}
{{- define "omero-server.volumes" -}}
- {name: omero-temp-dir, emptyDir: {}}
{{- end }}
