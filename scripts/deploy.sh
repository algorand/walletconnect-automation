#!/bin/bash

set -e

usage() { echo "Usage: $0 [-l VERSION] [-r AWS_REGION] [-n NAMESPACE] [-c CLASSIFIER] [-h]" 1>&2; exit "$1"; }

VERSION='latest'
NAMESPACE='dev'
AWS_REGION='us-east-2'
CLASSIFIER='default'

while getopts "v:r:n:c:h" o; do
    case "${o}" in
        v)
            VERSION="${OPTARG}"
            ;;
        r)
            AWS_REGION="${OPTARG}"
            ;;
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

REPOSITORY_URL=$(aws ecr describe-repositories --region "${AWS_REGION}" --repository-name "walletconnect/relay-server" | jq -r '.repositories[0].repositoryUri') || \
  (echo "Image version ${VERSION} does not exist in ECR. Please run build and publish"; exit 2)

helm upgrade --install wallet-connect-bridge-"${CLASSIFIER}" "${SCRIPT_PATH}"/../chart \
    --create-namespace \
    --namespace "${NAMESPACE}" \
    -f "${SCRIPT_PATH}"/../values/"${NAMESPACE}".yaml \
    --set walletconnect.classifier="${CLASSIFIER}" \
    --set walletconnect.deployment.image="${REPOSITORY_URL}" \
    --set walletconnect.deployment.tag="${VERSION}"
