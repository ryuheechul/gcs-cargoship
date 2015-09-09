FROM python:2.7-slim

MAINTAINER Heechul Ryu ryu@seworks.co

RUN sed -i 's/archive.ubuntu.com/ftp.kaist.ac.kr/g' /etc/apt/sources.list

RUN apt-get update

RUN apt-get install gcc python-dev python-setuptools libssl-dev libffi-dev -y

RUN apt-get install expect -y

#RUN pip install PyOpenSSL

RUN pip install -U gsutil

RUN pip install cherrypy

RUN mkdir -p /home/gcs-service/auth
COPY ./auth/* /home/gcs-service/auth/
WORKDIR /home/gcs-service/auth/
RUN ./auth-gsutil.sh "gsutil config -e"

RUN mkdir -p /home/gcs-service/web
COPY ./web/* /home/gcs-service/web/
WORKDIR /home/gcs-service/web


#COPY . /
