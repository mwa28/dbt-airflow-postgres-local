FROM docker.io/ubuntu/airflow:3.1-24.04_edge

USER root

COPY ./ingestion/requirements.txt /requirements.txt

RUN pip3 install --break-system-packages --no-cache-dir -r /requirements.txt
