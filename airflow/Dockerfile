FROM apache/airflow:3.4.0
USER airflow
RUN python -m venv /home/airflow/dbt_venv \
 && /home/airflow/dbt_venv/bin/pip install --no-cache-dir dbt-snowflake
