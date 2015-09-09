#!/bin/bash
#docker build -t python-gsutil .
./build.sh

source .env

docker run -it -p 8080:8080 -v $(pwd)/files:/home/gcs-service/files \
	-e GCS_BUCKET_NAME="$GCS_BUCKET_NAME" \
	-e GC_SECRET_PATH="$GC_SECRET_PATH" \
	-e GC_SECRET_PASSWORD="$GC_SECRET_PASSWORD" \
	-e GC_SERVICE_ACCOUNT="$GC_SERVICE_ACCOUNT" \
	-e GC_PROJECT_ID="$GC_PROJECT_ID" \
	python-gsutil python web.py

