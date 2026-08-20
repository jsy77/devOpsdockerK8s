pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Source code should already be checked out by Jenkins.'
                sh '''
                    echo "Current workspace:"
                    pwd

                    echo "Workspace contents:"
                    ls -la
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "=============================="
                    echo "DOCKER BUILD"
                    echo "=============================="

                    docker build -t devops-app:1.0 .
                '''
            }
        }

        stage('Docker Verify') {
            steps {
                sh '''
                    echo "=============================="
                    echo "DOCKER VERIFY"
                    echo "=============================="

                    docker images | grep devops-app
                '''
            }
        }
    }
}
