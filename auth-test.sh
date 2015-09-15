#!/bin/bash
./build.sh

source .env
docker run -t \
	-e GCS_BUCKET_NAME="$GCS_BUCKET_NAME" \
	-e GC_SECRET_PATH="$GC_SECRET_PATH" \
	-e GC_SECRET_PASSWORD="$GC_SECRET_PASSWORD" \
	-e GC_SERVICE_ACCOUNT="$GC_SERVICE_ACCOUNT" \
	-e GC_PROJECT_ID="$GC_PROJECT_ID" \
	gcs-cargoship gsutil ls
