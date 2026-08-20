pipeline {
    agent any

    environment {
        IMAGE_NAME = "jsy77/devops"
        KUBECONFIG = "/home/jenkinsuser/.kube/config"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    echo "Image: ${IMAGE_NAME}:v${BUILD_NUMBER}"

                    docker build \
                        -t ${IMAGE_NAME}:v${BUILD_NUMBER} .
                '''
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerHub_creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    echo "Pushing Docker image..."
                    docker push ${IMAGE_NAME}:v${BUILD_NUMBER}
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    echo "Deploying image to Kubernetes..."
                    echo "Image: ${IMAGE_NAME}:v${BUILD_NUMBER}"

                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        set image deployment/devops-app \
                        devops-app=${IMAGE_NAME}:v${BUILD_NUMBER}

                    echo "Waiting for rollout..."

                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        rollout status deployment/devops-app
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    echo "Kubernetes Deployment:"
                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        get deployment devops-app

                    echo ""
                    echo "Kubernetes Pods:"
                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        get pods -l app=devops-app -o wide

                    echo ""
                    echo "Kubernetes Service:"
                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        get service devops-service
                '''
            }
        }
    }
}
