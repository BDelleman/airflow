#!/bin/bash
#
# This script sets the variables in Composer. The variables are needed for the
# data processing DAGs to properly execute, such as project-id, GCP region and
#zone. It also sets Cloud Storage buckets where test files are stored.

declare -A variables
variables["gcp_project"]="${GCP_PROJECT_ID}"
variables["gcp_region"]="${COMPOSER_REGION}"
variables["gcp_zone"]="${COMPOSER_ZONE_ID}"
variables["gcs_input_bucket_test"]="${INPUT_BUCKET_TEST}"
variables["gcs_input_bucket_prod"]="${INPUT_BUCKET_TEST_PROD}"

for i in "${!variables[@]}"; do
  gcloud composer environments run "${COMPOSER_ENV_NAME}" \
  --location "${COMPOSER_REGION}" variables -- --set "${i}" "${variables[$i]}"
done