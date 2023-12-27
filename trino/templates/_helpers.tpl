{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "trino.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "trino.fullname" -}}
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
{{- define "trino.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "trino.coordinator" -}}
{{- if .Values.coordinatorNameOverride }}
{{- .Values.coordinatorNameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}-coordinator
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}-coordinator
{{- end }}
{{- end }}
{{- end }}

{{- define "trino.worker" -}}
{{- if .Values.workerNameOverride }}
{{- .Values.workerNameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}-worker
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}-worker
{{- end }}
{{- end }}
{{- end }}


{{- define "trino.catalog" -}}
{{ template "trino.fullname" . }}-catalog
{{- end -}}

{{- define "trino.network-policy" -}}
{{ template "trino.fullname" . }}-network-policy
{{- end -}}

{{- define "trino.metrics" -}}
{{ template "trino.fullname" . }}-metrics
{{- end }}

{{/*
Common labels
*/}}
{{- define "trino.labels" -}}
helm.sh/chart: {{ include "trino.chart" . }}
{{ include "trino.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "trino.selectorLabels" -}}
app.kubernetes.io/name: {{ include "trino.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "trino.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "trino.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Merge the accessControl delta lake and other rules
*/}}
{{- define "trino.accessControlRules" -}}
{{- if or .Values.accessControl.deltaLakeRules.catalogs .Values.accessControl.otherRules.catalogs -}}
catalogs:
  {{- with .Values.accessControl.otherRules.catalogs }}
  {{- . | toYaml | nindent 2}}
  {{- end }}
  {{- with .Values.accessControl.deltaLakeRules.catalogs }}
  {{- . | toYaml | nindent 2}}
  {{- end }}
{{- else }}
catalogs: []
{{- end }}
{{- if or .Values.accessControl.deltaLakeRules.schemas .Values.accessControl.otherRules.schemas }}
schemas:
  {{- with .Values.accessControl.otherRules.schemas }}
  {{- . | toYaml | nindent 2}}
  {{- end }}
  {{- with .Values.accessControl.deltaLakeRules.schemas }}
  {{- . | toYaml | nindent 2}}
  {{- end }}
{{- else }}
schemas: []
{{- end }}
{{- if or .Values.accessControl.deltaLakeRules.tables .Values.accessControl.otherRules.tables }}
tables:
  {{- with .Values.accessControl.otherRules.tables }}
  {{- . | toYaml | nindent 2}}
  {{- end }}
  {{- with .Values.accessControl.deltaLakeRules.tables }}
  {{- . | toYaml | nindent 2}}
  {{- end }}
{{- else }}
tables: []
{{- end }}
procedures:
  - user: ".*"
    privileges:
      - EXECUTE
      - GRANT_EXECUTE
{{- end }}
