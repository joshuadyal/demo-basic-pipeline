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
        docker.image('mcr.microsoft.com/dotnet/sdk:8.0')
            .inside("""
                        -e HOME="${env.WORKSPACE}"
                        -e DOTNET_CLI_HOME="${env.WORKSPACE}/.dotnet"
                        -e DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
                    """) {

            sh 'dotnet restore'
            sh 'dotnet build --no-restore'
        }
    }

    stage ("Test") {
        docker.image('mcr.microsoft.com/dotnet/sdk:8.0')
            .inside("""
                        -e HOME="${env.WORKSPACE}"
                        -e DOTNET_CLI_HOME="${env.WORKSPACE}/.dotnet"
                        -e DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
                    """) {

            sh 'dotnet test --no-build'
        }
    }
}