pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t devops-app:1.0 .'
            }
        }

        stage('Docker Verify') {
            steps {
                sh 'docker images | grep devops-app'
            }
        }
    }
}
