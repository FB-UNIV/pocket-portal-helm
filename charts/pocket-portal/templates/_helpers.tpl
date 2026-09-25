{{- define "pocket-portal.fullname" -}}
{{- if contains .Chart.Name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "pocket-portal.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "pocket-portal.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: portal
{{- end -}}

{{- /* Cut to 52 first: "-postgresql" is 11, so a long release name can't
  truncate back to the portal's own name and collide with its Service. */}}
{{- define "pocket-portal.postgresql.name" -}}
{{- printf "%s-postgresql" (include "pocket-portal.fullname" . | trunc 52 | trimSuffix "-") -}}
{{- end -}}

{{- define "pocket-portal.secretName" -}}
{{- .Values.secrets.existingSecret | default (include "pocket-portal.fullname" .) -}}
{{- end -}}

{{- define "pocket-portal.image" -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default (printf "v%s" .Chart.AppVersion)) -}}
{{- end -}}
