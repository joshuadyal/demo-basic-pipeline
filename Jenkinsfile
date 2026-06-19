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
            --network jenkins-net
            -u root
            -e HOME=${env.WORKSPACE}
            -e DOTNET_CLI_HOME=${env.WORKSPACE}/.dotnet
            -e DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
            -v /var/jenkins_home/.nuget:${env.WORKSPACE}/.nuget

        """) {

        stage ("Trivy filesystem scan") {
            sh '''
                trivy fs \
                --format template \
                --template "@/usr/local/share/trivy/templates/html.tpl" \
                --output trivy-report.html \
                .
            '''
        }

        stage ("Archive Trivy FS scan") {
            
            archiveArtifacts artifacts: 'trivy-report.html', allowEmptyArchive: false

        }
 
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

        
        stage("Quality Gate") {
            timeout(time: 10, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
            }
        }

    }
}