import airflow
from airflow import models
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.papermill_operator import PapermillOperator

project = models.Variable.get('gcp_project')
region = models.Variable.get('gcp_region')
zone = models.Variable.get('gcp_zone')
input_bucket = 'gs://' + models.Variable.get('gcs_input_bucket_test')
output_bucket_name = models.Variable.get('gcs_output_bucket_test')
output_bucket = 'gs://' + output_bucket_name
output_prefix = 'output'

default_args = {
    'start_date': airflow.utils.dates.days_ago(0),
    'schedule_interval': '@daily',
    'project': project,
    'zone': zone,
    'region': region,

}
with models.DAG(
    'regression_models',
    default_args=default_args) as dag:
    check_buckets = BashOperator(
        task_id='check_buckets',
        bash_command='echo $input_bucket',
    )
    data_preprocessing = PapermillOperator(
        task_id='data_preprocessing',
        input_nb=input_bucket+'/data_preprocessing.ipynb',
        output_nb='/home/airflow/gcs/data/data_preprocessing_out.ipynb',
        parameters={},
    )


""""


multi_linear_regression = PapermillOperator(
    task_id='multi_linear_regression',
    input_nb='/home/airflow/gcs/data/multi_linear_regression.ipynb',
    output_nb='/home/airflow/gcs/data/multi_linear_regression_out.ipynb',
    parameters={},
    dag=dag
)


random_forest_regression = PapermillOperator(
    task_id='random_forest_regression',
    input_nb='/home/airflow/gcs/data/random_forest_regression.ipynb',
    output_nb='/home/airflow/gcs/data/random_forest_regression_out.ipynb',
    parameters={},
    dag=dag
)


evaluate_models = PapermillOperator(
    task_id='data_processing',
    input_nb='/home/airflow/gcs/data/evaluate_models.ipynb',
    output_nb='/home/airflow/gcs/data/evaluate_models_out.ipynb',
    parameters={},
    dag=dag
)

cleanup = PapermillOperator(
    task_id='data_processing',
    input_nb='/home/airflow/gcs/data/cleanup.ipynb',
    output_nb='/home/airflow/gcs/data/cleanup_out.ipynb',
    parameters={},
    dag=dag
)
"""
check_buckets >> data_preprocessing