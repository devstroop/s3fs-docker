#!/bin/bash
set -euo pipefail
set -o errexit
set -o errtrace
IFS=$'\n\t'

mkdir -p /mnt/$S3_BUCKET

s3-mount -f $S3_BUCKET /mnt/$S3_BUCKET --allow-other