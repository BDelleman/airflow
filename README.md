# Airflow
Repository to create Airflow instance on google cloud

#Preqrequisites
- Google account
- Google cloud project with billing enabled
- Enable the following API's: composer, cloudbuild, trigger

#Tutorial

git clone https://github.com/BDelleman/airflow.git
cd ~/airflow/env-setup
source set_env.sh

gcloud composer environments create $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --zone $COMPOSER_ZONE_ID \
    --machine-type n1-standard-1 \
    --node-count 3 \
    --disk-size 20 \
    --python-version 3

#Set composer variables

cd ~/airflow/env-setup
chmod +x set_composer_variables.sh
./set_composer_variables.sh

#Create buckets for in - and output

cd ~/airflow/env-setup
chmod +x create_buckets.sh
./create_buckets.sh

#Add composer.admin role to the Cloud Build service account so the Cloud Build job can set Airflow variables in Cloud Composer

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role=roles/composer.admin

#Add the composer.worker role to the Cloud Build service account so the Cloud Build job can trigger the data workflow in Cloud Composer

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role=roles/composer.worker

cd ~/airflow/source-code/build-pipeline
gcloud builds submit --config=build-deploy.yaml --substitutions=\
REPO_NAME=$SOURCE_CODE_REPO,\
_COMPOSER_INPUT_BUCKET=$INPUT_BUCKET_TEST,\
_COMPOSER_DAG_BUCKET=$COMPOSER_DAG_BUCKET,\
_COMPOSER_ENV_NAME=$COMPOSER_ENV_NAME,\
_COMPOSER_REGION=$COMPOSER_REGION,\
_COMPOSER_DAG_NAME_TEST=$COMPOSER_DAG_NAME_TEST

gcloud composer environments update $COMPOSER_ENV_NAME \\
--update-pypi-packages-from-file ~/airflow/env-setup/requirements.txt \\
--location ${COMPOSER_REGION}


#CHECKPOINT WERKT