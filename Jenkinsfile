@Library('my-shared-library') _


node {
    stage ("Print hello and timestamp") {
        sayHello()
        printDate()
    }

    stage ("Checkout") {
        checkout scm
    }

    stage ("Build") {
        docker.image('mcr.microsoft.com/dotnet/sdk:8.0').inside {        
            withEnv([
                'DOTNET_CLI_HOME=/tmp',
                'HOME=/tmp'
            ]) {
                sh 'dotnet restore'
                sh 'dotnet build --no-restore'
            }
        }
    }

    stage ("Test") {
        docker.image('mcr.microsoft.com/dotnet/sdk:8.0').inside {
            sh 'dotnet test --no-build'
        }
    }
    
}