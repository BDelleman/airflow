#!/bin/bash
#
# This script sets the environment variables for project environment specific
# information such as project_id, region and zone choice. And also name of
# buckets that are used by the build pipeline and the data processing workflow.

export TEST='test'
export GCP_PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export PROJECT_NUMBER=$(gcloud projects describe "${GCP_PROJECT_ID}" --format='get(projectNumber)')
export INPUT_BUCKET_TEST="${GCP_PROJECT_ID}-composer-input-${TEST}"

export COMPOSER_REGION='europe-west3'
export RESULT_BUCKET_REGION="${COMPOSER_REGION}"
export COMPOSER_ZONE_ID='europe-west3-c'

export COMPOSER_ENV_NAME='airflowdemotest'
export COMPOSER_DAG_NAME_TEST='regression_models'
export SOURCE_CODE_REPO='airflow'

#TODO script aanroepen en dan deze variables setten