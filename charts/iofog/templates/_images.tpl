{{- define "iofog.image" -}}
{{- .root.Values.images.repository | default "ghcr.io/ctron" }}/{{- .image -}}:{{- include "iofog.image-tag" .root -}}
{{- end -}}

{{- define "iofog.image-tag" -}}
{{- .Values.images.tag | default .Chart.AppVersion -}}
{{- end -}}

{{- define "iofog.image-pull-policy" -}}
{{- with .Values.images.pullPolicy }}{{ . }}
{{- else }}
{{- if (eq (include "iofog.image-tag" .) "latest") }}Always{{ else }}IfNotPresent{{ end }}
{{- end }}
{{- end }}
