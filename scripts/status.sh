#!/bin/bash
set -e

usage() { echo "Usage: $0 [-n NAMESPACE] [-c CLASSIFIER] [-h]" 1>&2; exit "$1"; }

NAMESPACE='dev'
CLASSIFIER='default'

while getopts "v:r:n:c:h" o; do
    case "${o}" in
        n)
            NAMESPACE="${OPTARG}"
            ;;
        c)
            CLASSIFIER="${OPTARG}"
            ;;
        h)
            usage 0
            ;;
        *)
            usage 2
            ;;
    esac
done

SCRIPT_PATH=$(dirname "${0}")

APP_NAME="wallet-connect-bridge-${CLASSIFIER}-${CLASSIFIER}"
URL=$(kubectl get ingress -n "${NAMESPACE}" "${APP_NAME}" -ojsonpath='{.spec.rules[].host}')
VERSION=$(kubectl get deployment -n "${NAMESPACE}" "${APP_NAME}" -ojsonpath='{.spec.template.metadata.labels.version}')

echo "VERSION: ${VERSION}"
echo "ENDPOINT: wss://${URL}/"
kubectl get pod -n "${NAMESPACE}" -l app="${APP_NAME}"
