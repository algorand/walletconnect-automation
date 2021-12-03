{{- define "fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.walletconnect.classifier | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hostname" -}}
{{- printf "%s.%s.%s.%s" "wallet-connect" .Values.walletconnect.classifier .Release.Namespace .Values.walletconnect.ingress.zone.domain -}}
{{- end -}}
