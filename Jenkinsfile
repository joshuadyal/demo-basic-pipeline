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
    docker.image('dotnet-sonar:latest')
        .inside("""
            -u root
            -e HOME=${env.WORKSPACE}
            -e DOTNET_CLI_HOME=${env.WORKSPACE}/.dotnet
            -e DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
        """) {

        withCredentials([string(credentialsId: 'jenkins-token', variable: 'JENKINS_TOKEN')]) {

            sh '''

                export PATH="$PATH:$DOTNET_CLI_HOME/.dotnet/tools"

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
}