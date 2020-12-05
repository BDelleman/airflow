#!/bin/bash

PROJECT_ID="terraform-295217 "
COMPOSER_ENV_NAME="airflowcluster"
COMPOSER_REGION="europe-west3"
COMPOSER_ZONE_ID="europe-west3-c"
echo "Using project" $PROJECT_ID

gcloud components update


gcloud config set project $PROJECT_ID
echo "Using project" $PROJECT_ID


gcloud composer environments create $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --zone $COMPOSER_ZONE_ID \
    --machine-type n1-standard-1 \
    --node-count 3 \
    --disk-size 20 \
    --python-version 3