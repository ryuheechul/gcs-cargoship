#!/bin/bash
cd auth
./generate-auth-gsutil.sh
cd ..
docker build -t python-gsutil .
