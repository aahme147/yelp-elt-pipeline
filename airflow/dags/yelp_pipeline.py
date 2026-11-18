from datetime import datetime
from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator

DBT = "/home/airflow/dbt_venv/bin/dbt"
DBT_ARGS = "--profiles-dir /opt/airflow/dbt_profiles --project-dir /opt/airflow/yelp"

with DAG(
    dag_id="yelp_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    load_next_month = BashOperator(
        task_id="load_next_month",
        bash_command=f"{DBT} run-operation load_next_month {DBT_ARGS}",
    )

    dbt_build_staging = BashOperator(
        task_id="dbt_build_staging",
        bash_command=f"{DBT} build --select stg_review fact_review {DBT_ARGS}",
    )

    dbt_snapshot = BashOperator(
        task_id="dbt_snapshot",
        bash_command=f"{DBT} snapshot {DBT_ARGS}",
    )

    dbt_build_marts = BashOperator(
        task_id="dbt_build_marts",
        bash_command=f"{DBT} build --select marts {DBT_ARGS}",
    )

    load_next_month >> dbt_build_staging >> dbt_snapshot >> dbt_build_marts