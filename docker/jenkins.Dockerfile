FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y docker.io
# RUN usermod -aG 1001 jenkins
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow json-path-api"