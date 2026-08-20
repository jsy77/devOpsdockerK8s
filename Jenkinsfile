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
                    echo "======================================"
                    echo "Building Docker Image"
                    echo "Image: ${IMAGE_NAME}:v${BUILD_NUMBER}"
                    echo "======================================"

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
                    echo "======================================"
                    echo "Pushing Docker Image"
                    echo "${IMAGE_NAME}:v${BUILD_NUMBER}"
                    echo "======================================"

                    docker push ${IMAGE_NAME}:v${BUILD_NUMBER}
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    echo "======================================"
                    echo "Applying Kubernetes configuration"
                    echo "======================================"

                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        apply -f deployment.yaml

                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        apply -f service.yaml
                '''
            }
        }

        stage('Rolling Update') {
            steps {
                script {

                    try {

                        sh '''
                            echo "======================================"
                            echo "Starting Rolling Update"
                            echo "New Image: ${IMAGE_NAME}:v${BUILD_NUMBER}"
                            echo "======================================"

                            kubectl \
                                --kubeconfig=${KUBECONFIG} \
                                set image deployment/devops-app \
                                devops-app=${IMAGE_NAME}:v${BUILD_NUMBER}
                        '''

                        sh '''
                            echo "Waiting for rollout..."

                            kubectl \
                                --kubeconfig=${KUBECONFIG} \
                                rollout status deployment/devops-app \
                                --timeout=60s
                        '''

                        echo "Rolling update successful."

                    } catch (Exception e) {

                        echo "======================================"
                        echo "ROLLING UPDATE FAILED"
                        echo "Starting automatic rollback"
                        echo "======================================"

                        sh '''
                            kubectl \
                                --kubeconfig=${KUBECONFIG} \
                                rollout undo deployment/devops-app
                        '''

                        sh '''
                            kubectl \
                                --kubeconfig=${KUBECONFIG} \
                                rollout status deployment/devops-app \
                                --timeout=60s
                        '''

                        echo "Rollback completed."

                        throw e
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    echo "======================================"
                    echo "Deployment"
                    echo "======================================"

                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        get deployment devops-app

                    echo ""
                    echo "======================================"
                    echo "Pods"
                    echo "======================================"

                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        get pods \
                        -l app=devops-app \
                        -o wide

                    echo ""
                    echo "======================================"
                    echo "Service"
                    echo "======================================"

                    kubectl \
                        --kubeconfig=${KUBECONFIG} \
                        get service devops-service
                '''
            }
        }
    }
}
