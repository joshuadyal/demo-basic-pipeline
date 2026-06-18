FROM mcr.microsoft.com/dotnet/sdk:8.0

RUN apt-get update && apt-get install -y openjdk-17-jre

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN dotnet tool install --global dotnet-sonarscanner
ENV PATH="$PATH:/root/.dotnet/tools"
