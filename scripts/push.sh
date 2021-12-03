#!/bin/bash

set +e

usage() { echo "Usage: $0 <-i IMAGE> [-r AWS_REGION] [-h]" 1>&2; exit "$1"; }

unset IMAGE

AWS_REGION='us-east-2'

while getopts "i:r:h" o; do
    case "${o}" in
        i)
            IMAGE=${OPTARG}
            ;;
        h)
            usage 0
            ;;
        r)
            AWS_REGION=${OPTARG}
            ;;
        *)
            usage 2
            ;;
    esac
done

if [ -z "${IMAGE}" ]; then
    echo "Missing required parameters"
    usage 2
fi

IMAGE_NAME=$(echo "${IMAGE}" | cut -d':' -f1)
IMAGE_VERSION=$(echo "${IMAGE}" | cut -d':' -f2)

# This command will fail most of the time. It's meant
# to ensure that the required ECR repository exists
aws ecr create-repository --region "${AWS_REGION}" --repository-name "${IMAGE_NAME}" 2> /dev/null
REPOSITORY_URL=$(aws ecr describe-repositories --region "${AWS_REGION}" --repository-name "${IMAGE_NAME}" | jq -r '.repositories[0].repositoryUri')

# aws changed from get-login to direct docker login starting in v2
if [[ "$(aws --version)" =~ ^aws-cli/1 ]]; then
  readonly ECR_LOGIN=$(aws ecr get-login --no-include-email --region "${AWS_REGION}")
  $ECR_LOGIN
else
  REPOSITORY_DOMAIN=${REPOSITORY_URL/${IMAGE_NAME}/}
  aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin ${REPOSITORY_DOMAIN}
fi

docker tag "${IMAGE}" "${REPOSITORY_URL}:${IMAGE_VERSION}"
docker push "${REPOSITORY_URL}:${IMAGE_VERSION}"
