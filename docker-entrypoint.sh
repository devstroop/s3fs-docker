#!/bin/bash
set -euo pipefail
set -o errexit
set -o errtrace
IFS=$'\n\t'

export S3_BUCKET=${S3_BUCKET:-}

mkdir -p ${MOUNT_POINT}

s3-mount -f ${S3_BUCKET} ${MOUNT_POINT} --allow-other