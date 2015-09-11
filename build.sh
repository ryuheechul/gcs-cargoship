#!/bin/bash -e
cd auth
./generate-auth-gsutil.sh
cd ..
docker build -t gcs-cargoship .
