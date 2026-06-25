# Pipeline Documentation
Jenkins, .NET and SonarQube

## Pre-requisites
- Docker Desktop (or any Docker Daemon)
- Shared library
- deploy.sh (for convenience)


## Docker Images
### Jenkins
```Dockerfile
FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y docker.io
# RUN usermod -aG 1001 jenkins
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow json-path-api"
```

This Dockerfile will get the latest stable Jenkins docker image and install the docker.io library, and the blueocean library for an alternative UI view.

### .NET image (with JDK 17)
```Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0

RUN apt-get update && apt-get install -y openjdk-17-jre

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"
```
This will take the .NET (dotnet) image, install JDK17 and set environment variables that will be used by the Jenkinsfile

## Shared library
Shared library is not required for this yet as the shared library is only used for the unnecessary echo 'hello world' stage.


## How to run

To run the jenkins server and sonar server, run `deploy.sh`:
```sh
# Clean up (remove containers but not volumes)
docker rm -f jenkins || true

cd ./dotnet-sonar
docker build -t dotnet-sonar:latest .

cd ..

# Start jenkins container
cd ./jenkins
docker build -t jenkins .

docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  --name jenkins \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add 1001 \
  jenkins
# Create a volume to persist Jenkins data

cd ..
```