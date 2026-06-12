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
            .inside("""
                -u 1000:1000
                -e HOME=${env.WORKSPACE}
                -e DOTNET_CLI_HOME=${env.WORKSPACE}/.dotnet
                -e DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
            """) {

            withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {

                sh '''
                    export PATH="$PATH:$HOME/.dotnet/tools"

                    dotnet tool install --global dotnet-sonarscanner

                    dotnet sonarscanner begin \
                    /k:"demo-dotnet" \
                    /d:sonar.host.url="http://host.docker.internal:9000" \
                    /d:sonar.login="$SONAR_TOKEN"

                    dotnet restore
                    dotnet build -c Release --no-restore
                    dotnet test -c Release --no-build --logger trx

                    dotnet sonarscanner end \
                    /d:sonar.login="$SONAR_TOKEN"
                '''
            }
        }
    }
}