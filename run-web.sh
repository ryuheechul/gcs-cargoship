#!/bin/bash -e
if [ -z $1 ]; then
	echo "please do ./run-web.sh [port]"
	exit 1
fi

port=$1

./build.sh

source .env

# kill and remove if gcs-cargo-container exist
bld_con="gcs-cargo-container"

prv_bld_con_alive=$(docker ps -f "name=$bld_con" -q)

if [ ! -z "$prv_bld_con_alive" ]; then
	docker kill $bld_con
fi

prv_bld_con=$(docker ps -f "name=$bld_con" -a -q)

if [ ! -z "$prv_bld_con" ]; then
	docker rm $bld_con
fi

# run container with docker image just built.

docker run --name $bld_con -d -p $port:$port -v $(pwd)/files:/home/gcs-cargoship/files \
	-e GCS_BUCKET_NAME="$GCS_BUCKET_NAME" \
	-e GC_SECRET_PATH="$GC_SECRET_PATH" \
	-e GC_SECRET_PASSWORD="$GC_SECRET_PASSWORD" \
	-e GC_SERVICE_ACCOUNT="$GC_SERVICE_ACCOUNT" \
	-e GC_PROJECT_ID="$GC_PROJECT_ID" \
	-e CHERRYPY_PORT="$port" \
	gcs-cargoship python web.py

