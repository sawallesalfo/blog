# Use the official Python image from the Docker Hub
FROM python:3.12-slim
USER root
LABEL maintainer="Salif SAWADOGO"

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install -y git


