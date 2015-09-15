# gcs-cargoship

A service that deliver files into Google Cloud Storage.

## Why?

- I needed to share files between clustered microservices using Google Cloud Storage.
- To share files between pods on multiple nodes on Kubernetes enviromnet on GKE(Google Container Engine).
> You don't need to use kubernetes or GKE to use this project though

- Wanted to make sure every service(container) on every pod can deliver same files to users no matter which node user is connecting.

## Requirements

#### Docker
> [docker is required to run this app.](https://docker.com)

#### Google Cloud Account
> you need to give an info about your google cloud info.

you need to have this info below
- Google Cloud Project ID
- Google Cloud Storage Bucket for the project.
- Google Cloud Service Account for the project.
- Google Cloud Private key file (p12) for service account in the project

##### **[how to get this info]**
- Ask this info to a system manager in your company/team
- Create via google cloud console(cloud.google.com). if you are a system manager or practicing on your own system.

## How to run the service?

### 1. Prepare .env file
> Put this file into project root path example/path/to/gcs-cargoship/.env

format)
```
GCS_BUCKET_NAME="BUCKET NAME"
GC_SECRET_PATH="PATH/secret.p12"
GC_SECRET_PASSWORD="SECRETCODE-FOR-PRIVATEKEY" 
GC_SERVICE_ACCOUNT="service@account.com"
GC_PROJECT_ID="project-id"
```

ex)
```
GCS_BUCKET_NAME="fuse-test"
GC_SECRET_PATH="/home/gcs-cargoship/auth/secret.p12"
GC_SECRET_PASSWORD="notasecret" 
GC_SERVICE_ACCOUNT="random_id@developer.gserviceaccount.com"
GC_PROJECT_ID="project-id-1234"
```

### 2. run with docker
> run-web.sh

### 3. connect with other docker container with volume mounting and port binding.

- docker
volume and ip,port.

- kubenetes
volume and localhost port.

### 4. put a file to upload into the path on the shared volume
> put a file into /home/gcs-cargoship/files/

### 5. Get downloadable url for uploaded file

#### 1) send a request via http to upload a file
> http://gcs-cargoship-ip:port/upload?filename=[filename]

#### 2) send a request to get downloadable url with bucket url
> http://gcs-cargoship-ip:port/download?filename=[filename]

#### 3) give your user the signed url to download the file.

### 6. send a request to delete unneed files after sometime user downloaded file. (Maybe daily basis)
> http://gcs-cargoship-ip:port/delete?filename=[filename]


