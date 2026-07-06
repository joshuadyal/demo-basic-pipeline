@Library('my-shared-library') _


node {
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

        stage ("Trivy FS scan") {
            sh '''
                trivy fs \
                --format template \
                --template "@/usr/local/share/trivy/templates/html.tpl" \
                --output trivy-filesystem-report.html \
                --exit-code 0 \
                --severity HIGH,CRITICAL \
                .
            '''
            
            archiveArtifacts artifacts: 'trivy-filesystem-report.html', allowEmptyArchive: false

            publishHTML([
                reportDir: '.',
                reportFiles: 'trivy-filesystem-report.html',
                reportName: 'Trivy FS Scan',
                keepAll: true,
                alwaysLinkToLastBuild: true,
                allowMissing: false
            ])
        }

 
        stage("Sonar scan & tests") {
            sh 'dotnet restore'

            withSonarQubeEnv('server-sonar') {
                sh 'dotnet sonarscanner begin /k:"demo-dotnet"'
            }


            sh 'dotnet build --no-restore'
            
            sh 'dotnet test --no-build'

            withSonarQubeEnv('server-sonar') {
                sh 'dotnet sonarscanner end'
            }
        }
        
        stage("Quality Gate") {
            timeout(time: 10, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: false
            }
        }

    

        stage("Trivy Image Scan") {
            sh 'docker build -t demo-dotnet-app -f docker/app.Dockerfile .'

            sh '''
                trivy image \
                --format template \
                --template "@/usr/local/share/trivy/templates/html.tpl" \
                --output trivy-image-report.html \
                --exit-code 0 \
                --severity HIGH,CRITICAL \
                demo-dotnet-app
            '''
            archiveArtifacts artifacts: 'trivy-image-report.html', allowEmptyArchive: false

            publishHTML([
                reportDir: '.',
                reportFiles: 'trivy-image-report.html',
                reportName: 'Trivy Image Scan',
                keepAll: true,
                alwaysLinkToLastBuild: true
            ])

            sh 'docker rmi demo-dotnet-app || true'
        }
    }
}