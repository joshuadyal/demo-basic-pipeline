@Library('my-shared-library') _


node {
    stage ("Print hello and timestamp") {
        sayHello()
        printDate()
    }

    stage ("Checkout") {
        checkout scm
    }


    docker.image('dotnet-sonar:latest')
        .inside("""
            -u root
            -e HOME=${env.WORKSPACE}
            -e DOTNET_CLI_HOME=${env.WORKSPACE}/.dotnet
            -e DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
            -v /var/jenkins_home/.nuget:${env.WORKSPACE}/.nuget

        """) {
 
        stage("Restore") {
            sh 'dotnet restore'
        }
 
        stage("SonarQube Begin") {
            withSonarQubeEnv('server-sonar') {
                sh 'dotnet sonarscanner begin /k:"demo-dotnet"'
            }
        }
 
        stage("Build") {
            sh 'dotnet build --no-restore'
        }
 
        stage("Test") {
            sh 'dotnet test --no-build'
        }
 
        stage("SonarQube End") {
            withSonarQubeEnv('server-sonar') {
                sh 'dotnet sonarscanner end'
            }
        }
    
    }
    
}