from datetime import datetime

import duckdb


def ingest(prefix: str, date: str):
    bucket = "csv"
    start_date = datetime.strptime(date, "%Y-%m-%d")

    files_today = f"s3://{bucket}/{prefix}/{start_date.year}/{start_date.month:02}/{start_date.day:02}/*.csv"

    con = duckdb.connect()

    # Load AWS extension
    _ = con.execute("INSTALL aws;")
    _ = con.execute("LOAD aws;")
    _ = con.execute("SET s3_endpoint='minio:9000';")
    _ = con.execute("SET s3_use_ssl=false;")
    _ = con.execute("SET s3_region='us-east-1';")
    _ = con.execute("SET s3_url_style='path';")
    _ = con.execute(
        """
        CREATE OR REPLACE SECRET secret (
            TYPE s3,
            PROVIDER config,
            KEY_ID 'minioadmin',
            SECRET 'minioadmin',
            REGION 'us-east-1'
        )
        """
    )
    _ = con.execute("INSTALL postgres;")
    _ = con.execute("LOAD postgres;")
    _ = con.execute(
        """
        ATTACH 'host=postgres port=5432 user=operator password=password dbname=analytics' AS postgres (TYPE postgres)"""
    )

    _ = con.execute(
        f"""
        CREATE TABLE {prefix} AS 
        SELECT *, today() as copied_at
        FROM read_csv($files, header=true, all_varchar=true)""",
        {"files": files_today},
    )

    _ = con.execute(
        """
        CREATE SCHEMA IF NOT EXISTS postgres.dev_raw;
    """
    )

    exists = con.execute(
        """
        SELECT * 
        FROM postgres.information_schema.tables 
        WHERE table_schema = 'dev_raw'
        AND table_name = $table
        """,
        {"table": prefix},
    ).fetchone()

    if exists:
        print("Table exists, copying data...")
        _ = con.execute(
            f"""
            COPY {prefix} TO 'postgres.dev_raw.{prefix}'
        """
        )
    else:
        print("No table was found, creating table...")
        _ = con.execute(
            f"""
        CREATE TABLE postgres.dev_raw.{prefix} AS
            FROM {prefix}
    """
        )


if __name__ == "__main__":
    import sys

    prefix = sys.argv[1]
    date = sys.argv[2]
    ingest(prefix, date)
