# Airflow cluster on Google Cloud

Repository to create Airflow instance on google cloud.

# Preqrequisites
- Google account
- Google cloud project with billing enabled
- Enable the following API's: composer, cloudbuild, trigger

# Tutorial
This tutorial will give you a step-by-step guide to create a cloud composer environment

Clone repo and set environment variables
```sh
git clone https://github.com/BDelleman/airflow.git
cd ~/airflow/env-setup
source set_env.sh
```
```sh
gcloud composer environments create $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --zone $COMPOSER_ZONE_ID \
    --machine-type n1-standard-1 \
    --node-count 3 \
    --disk-size 20 \
    --python-version 3 \
    --airflow-version 1.10.12
```
Set composer variables

```sh
cd ~/airflow/env-setup
chmod +x set_composer_variables.sh
./set_composer_variables.sh
```

Install new pypi packages in cluster

```sh
gcloud composer environments update $COMPOSER_ENV_NAME \
--update-pypi-packages-from-file ~/airflow/env-setup/requirements.txt \
--location ${COMPOSER_REGION}
```

Add the composer.worker role to the Cloud Build service account so the Cloud Build job can trigger the data workflow in Cloud Composer

```sh
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role=roles/composer.worker
```
Export URL for bucket as env variable

```sh
export COMPOSER_DAG_BUCKET=$(gcloud composer environments describe $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --format="get(config.dagGcsPrefix)")
```

Export name of service account in order to have access to bucket

```sh
export COMPOSER_SERVICE_ACCOUNT=$(gcloud composer environments describe $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --format="get(config.nodeConfig.serviceAccount)")
```
Create buckets for in - and output

```sh
cd ~/airflow/env-setup
chmod +x create_buckets.sh
./create_buckets.sh
```

Trigger cloud build

```sh
cd ~/airflow/source-code/build-pipeline
gcloud builds submit --config=build-deploy.yaml --substitutions=\
REPO_NAME=$SOURCE_CODE_REPO,\
_COMPOSER_INPUT_BUCKET=$INPUT_BUCKET_TEST,\
_COMPOSER_DAG_BUCKET=$COMPOSER_DAG_BUCKET,\
_COMPOSER_ENV_NAME=$COMPOSER_ENV_NAME,\
_COMPOSER_REGION=$COMPOSER_REGION,\
_COMPOSER_DAG_NAME_TEST=$COMPOSER_DAG_NAME_TEST
```

Now that we see our build is working we want to trigger it with every commit. 
#TODO 
Add steps for build trigger, database