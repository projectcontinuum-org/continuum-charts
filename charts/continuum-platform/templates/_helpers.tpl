{{/*
Expand the name of the chart.
*/}}
{{- define "continuum-platform.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "continuum-platform.fullname" -}}
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
Common labels
*/}}
{{- define "continuum-platform.labels" -}}
helm.sh/chart: {{ include "continuum-platform.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: continuum
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "continuum-platform.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Full label set for a resource belonging to a given component, with global and
per-service overrides layered on top.
Merge precedence (highest wins): extra > global.labels > component + base labels.
Usage: {{ include "continuum-platform.componentLabels" (dict "context" $ "component" "api-server" "extra" .Values.continuum.apiServer.labels.deployment) | nindent 4 }}
*/}}
{{- define "continuum-platform.componentLabels" -}}
{{- $result := dict -}}
{{- $result = mergeOverwrite $result (dict "app.kubernetes.io/component" .component) -}}
{{- $result = mergeOverwrite $result (include "continuum-platform.labels" .context | fromYaml) -}}
{{- $result = mergeOverwrite $result (.context.Values.global.labels | default dict) -}}
{{- $result = mergeOverwrite $result (.extra | default dict) -}}
{{- toYaml $result -}}
{{- end }}

{{/*
Full annotation set for a resource, with global and per-service overrides
layered on top. Renders to nothing if there are no annotations to set.
Merge precedence (highest wins): extra > global.annotations.
Usage: {{- with (include "continuum-platform.componentAnnotations" (dict "context" $ "extra" .Values.continuum.apiServer.annotations.deployment)) }}
annotations:
  {{- nindent 4 . }}
{{- end }}
*/}}
{{- define "continuum-platform.componentAnnotations" -}}
{{- $result := dict -}}
{{- $result = mergeOverwrite $result (.context.Values.global.annotations | default dict) -}}
{{- $result = mergeOverwrite $result (.extra | default dict) -}}
{{- if $result -}}
{{ toYaml $result }}
{{- end -}}
{{- end }}

{{/* ======================== Infra service references ======================== */}}

{{- define "continuum-platform.infra.temporal.address" -}}
{{- .Values.continuum.infra.temporal.host -}}:{{- .Values.continuum.infra.temporal.port -}}
{{- end }}

{{- define "continuum-platform.infra.db.url" -}}
jdbc:postgresql://{{ .Values.continuum.infra.postgresql.host }}:{{ .Values.continuum.infra.postgresql.port }}/{{ .Values.continuum.infra.postgresql.database }}
{{- end }}

{{- define "continuum-platform.infra.mosquitto.uri" -}}
tcp://{{ .Values.continuum.infra.mosquitto.host }}:{{ .Values.continuum.infra.mosquitto.port }}
{{- end }}

{{/* ======================== Secret names ======================== */}}

{{- define "continuum-platform.postgresql.secretName" -}}
{{- if .Values.continuum.secrets.existingPostgresqlSecret -}}
{{- .Values.continuum.secrets.existingPostgresqlSecret -}}
{{- else -}}
{{- include "continuum-platform.fullname" . -}}-postgresql-secret
{{- end -}}
{{- end }}

{{- define "continuum-platform.minio.secretName" -}}
{{- if .Values.continuum.secrets.existingMinioSecret -}}
{{- .Values.continuum.secrets.existingMinioSecret -}}
{{- else -}}
{{- include "continuum-platform.fullname" . -}}-minio-secret
{{- end -}}
{{- end }}

{{/* ======================== Component fullnames ======================== */}}

{{- define "continuum-platform.api-server.fullname" -}}
{{- include "continuum-platform.fullname" . -}}-api-server
{{- end }}

{{- define "continuum-platform.orchestration-service.fullname" -}}
{{- include "continuum-platform.fullname" . -}}-orchestration-service
{{- end }}

{{- define "continuum-platform.message-bridge.fullname" -}}
{{- include "continuum-platform.fullname" . -}}-message-bridge
{{- end }}

{{- define "continuum-platform.feature-base.fullname" -}}
{{- include "continuum-platform.fullname" . -}}-feature-base
{{- end }}

{{- define "continuum-platform.feature-cheminformatics.fullname" -}}
{{- include "continuum-platform.fullname" . -}}-feature-cheminformatics
{{- end }}

{{- define "continuum-platform.cluster-manager.fullname" -}}
{{- include "continuum-platform.fullname" . -}}-cluster-manager
{{- end }}

{{- define "continuum-platform.cloud-gateway.fullname" -}}
{{- include "continuum-platform.fullname" . -}}-cloud-gateway
{{- end }}

{{- define "continuum-platform.credentials-server.fullname" -}}
{{- include "continuum-platform.fullname" . -}}-credentials-server
{{- end }}


