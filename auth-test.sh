#!/bin/bash
docker build -t python-gsutil .

source .env
docker run -it \
	-e GCS_BUCKET_NAME="$GCS_BUCKET_NAME" \
	-e GC_SECRET_PATH="$GC_SECRET_PATH" \
	-e GC_SECRET_PASSWORD="$GC_SECRET_PASSWORD" \
	-e GC_SERVICE_ACCOUNT="$GC_SERVICE_ACCOUNT" \
	-e GC_PROJECT_ID="$GC_PROJECT_ID" \
	python-gsutil gsutil ls

