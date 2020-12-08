#!/bin/bash
#
# This script creates the buckets used by the build pipelines and the data
# processing workflow. It also gives the Cloud Composer service account the
# access level it need to execute the data processing workflow

gsutil ls -L "gs://${INPUT_BUCKET_TEST}" 2>/dev/null \
|| gsutil mb -c regional -l "${COMPOSER_REGION}" "gs://${INPUT_BUCKET_TEST}"
gsutil ls -L "gs://${INPUT_BUCKET_TEST}" 2>/dev/null \
|| gsutil mb -c regional -l "${COMPOSER_REGION}" "gs://${INPUT_BUCKET_PROD}"


gsutil acl ch -u "${COMPOSER_SERVICE_ACCOUNT}:R" \
"gs://${INPUT_BUCKET_TEST}"
gsutil acl ch -u "${COMPOSER_SERVICE_ACCOUNT}:R" \
"gs://${INPUT_BUCKET_PROD}"

