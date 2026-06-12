@Library('my-shared-library') _


node {
    stage ("Print hello and timestamp") {
        sayHello()
        printDate()
    }

    stage ("Checkout") {
        checkout scm
    }


    stage("Sonar Scan") {
    docker.image('mcr.microsoft.com/dotnet/sdk:8.0')
        .inside('--user root') {

        withEnv([
            "HOME=${env.WORKSPACE}",
            "DOTNET_CLI_HOME=${env.WORKSPACE}/.dotnet",
            "DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1"
        ]) {

            withCredentials([string(credentialsId: 'jenkins-token', variable: 'JENKINS_TOKEN')]) {

                sh '''
                    set -e

                    apt-get update && apt-get install -y openjdk-21-jre

                    export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
                    export PATH="$JAVA_HOME/bin:$PATH:$DOTNET_CLI_HOME/.dotnet/tools"

                    echo "=== JAVA CHECK ==="
                    java -version
                    which java

                    dotnet tool install --global dotnet-sonarscanner || true

                    dotnet sonarscanner begin \
                      /k:"demo-dotnet" \
                      /d:sonar.host.url="http://host.docker.internal:9000" \
                      /d:sonar.login="$JENKINS_TOKEN"

                    dotnet restore
                    dotnet build -c Release --no-restore
                    dotnet test -c Release --no-build --logger trx

                    dotnet sonarscanner end \
                      /d:sonar.login="$JENKINS_TOKEN"
                '''
            }
        }
    }

    junit '**/*.trx'
}
}