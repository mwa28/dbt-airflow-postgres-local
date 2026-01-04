from datetime import datetime, timedelta

from airflow.providers.standard.operators.bash import BashOperator
from airflow.sdk import Param

from airflow import DAG

DBT_DIR = "/opt/dbt"
INGESTION_DIR = "/opt/ingestion"

with DAG(
    "rl_etl_daily",
    start_date=datetime(2026, 1, 4),
    schedule=timedelta(days=1),
    catchup=False,
    tags=["dev"],
    params={"full_refresh": Param(default=False, type="boolean")},
) as dag:

    dbt_command = (
        f"cd {DBT_DIR} && "
        "dbt run "
        "{% if params.full_refresh %} --full-refresh {% endif %} "
        "--select"
    )

    raw_sales = BashOperator(
        task_id="sales_raw_ingestion",
        bash_command=f"cd {INGESTION_DIR} && python3 ingest_raw_data.py sales {{{{ ds }}}}",
    )

    raw_leads = BashOperator(
        task_id="leads_raw_ingestion",
        bash_command=f"cd {INGESTION_DIR} && python3 ingest_raw_data.py leads {{{{ ds }}}}",
    )

    staging = BashOperator(
        task_id="staging_layer",
        bash_command=f"{dbt_command} staging",
    )

    dq = BashOperator(task_id="dq_layer", bash_command=f"{dbt_command} dq")

    clean = BashOperator(task_id="clean_layer", bash_command=f"{dbt_command} clean")

    marts = BashOperator(task_id="marts_layer", bash_command=f"{dbt_command} marts")

    [raw_sales, raw_leads] >> staging >> dq >> clean >> marts
