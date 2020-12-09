{{- define "http-server.matchLabels" -}}
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/part-of: "{{ .Chart.Name }}"
app.kubernetes.io/name: "http-server"
{{- end -}}

{{- define "http-server.metaLabels" -}}
{{ include "http-server.matchLabels" $ }}
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
app.kubernetes.io/managed-by: "{{ .Release.Service }}"
{{- if .Chart.AppVersion -}}
app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
{{- end -}}
{{- end -}}
