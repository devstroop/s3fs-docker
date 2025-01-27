#!/bin/bash
set -euo pipefail
set -o errexit
set -o errtrace
IFS=$'\n\t'

export S3_BUCKET=${S3_BUCKET:-}
export MOUNT_POINT=${MOUNT_POINT:-}

mkdir -p $MOUNT_POINT

s3-mount -f $S3_BUCKET $MOUNT_POINT --allow-other