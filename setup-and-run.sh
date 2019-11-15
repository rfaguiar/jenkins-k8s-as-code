#!/usr/bin/env bash

dockerhub_user=rfaguiar

jenkins_port=8080
image_name=jenkins-as-code
image_version=2.0.1
container_name=jenkins

if [ ! -d downloads ]; then
    mkdir downloads
    curl -o downloads/jdk-8u202-linux-x64.tar.gz https://download.oracle.com/otn/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/jdk-8u202-linux-x64.tar.gz
    curl -o downloads/jdk-7u80-linux-x64.tar.gz https://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
    curl -o downloads/apache-maven-3.5.2-bin.tar.gz https://archive.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
fi

docker stop ${container_name}

docker build --no-cache -t ${dockerhub_user}/${image_name}:${image_version} .

if [ ! -d m2deps ]; then
    mkdir m2deps
fi
if [ -d jobs ]; then
    rm -rf jobs
fi
if [ ! -d jobs ]; then
    mkdir jobs
fi

docker run -p ${jenkins_port}:8080 \
    -v `pwd`/downloads:/var/jenkins_home/downloads \
    -v `pwd`/jobs:/var/jenkins_home/jobs/ \
    -v `pwd`/m2deps:/var/jenkins_home/.m2/repository/ \
    -v $HOME/.ssh:/var/jenkins_home/.ssh/ \
    --rm --name ${container_name}-v${image_version} \
    ${dockerhub_user}/${image_name}:${image_version}