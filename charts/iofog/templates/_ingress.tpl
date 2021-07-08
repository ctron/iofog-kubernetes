{{- define "iofog.viewer-host" -}}
    {{- with .Values.ingress.viewer.host -}}
        {{- . -}}
    {{- else -}}
        viewer-{{ .Release.Namespace}}{{ .Values.ingress.domain -}}
    {{- end }}
{{- end }}

{{- define "iofog.viewer-url" -}}
{{- .Values.ingress.viewer.protocol -}}://{{ include "iofog.viewer-host" . -}}
{{- end }}

{{- define "iofog.api-host" -}}
    {{- with .Values.ingress.api.host -}}
        {{- . -}}
    {{- else -}}
        api-{{ .Release.Namespace}}{{ .Values.ingress.domain -}}
    {{- end }}
{{- end }}

{{- define "iofog.api-url" -}}
{{- .Values.ingress.api.protocol -}}://{{ include "iofog.api-host" . -}}
{{- end }}
