FROM mcr.microsoft.com/dotnet/sdk:8.0

RUN apt-get update && apt-get install -y openjdk-17-jre curl docker.io

RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
    | sh -s -- -b /usr/local/bin

# Add HTML template
RUN mkdir -p /usr/local/share/trivy/templates

RUN curl -o /usr/local/share/trivy/templates/html.tpl \
    https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN dotnet tool install --global dotnet-sonarscanner
ENV PATH="$PATH:/root/.dotnet/tools"
