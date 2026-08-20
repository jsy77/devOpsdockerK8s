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
                    
                    echo "Building image: devops-app:${BUILD_NUMBER}"
                    docker build -t devops-app:${BUILD_NUMBER} .
                    
                '''
            }
        }

        stage('chekcing available images') {
            steps {
                sh '''
                    echo "=============================="
                    echo "DOCKER VERIFY"
                    echo "=============================="

                    docker images | grep devops-app
                '''
            }
        }
        

        stage('Docker Run') {
           steps {
                sh '''
                  echo "=============================="
                  echo "DOCKER RUN"
                  echo "=============================="

                  echo "Starting container: devops-app-${BUILD_NUMBER}"

                  docker run -d \
                      --name devops-app-${BUILD_NUMBER} \
                      -p 8087:80 \
                      devops-app:${BUILD_NUMBER}

                  echo ""
                  echo "Running containers:"
                  docker ps
                  '''
           } 
         }        
 
        stage('Docker Verify') {
    		steps {
        	sh '''
            	echo "=============================="
            	echo "DOCKER VERIFY"
            	echo "=============================="

            	echo "Verifying image: devops-app:${BUILD_NUMBER}"

            	docker image inspect devops-app:${BUILD_NUMBER}

            	echo ""
            	echo "Image verified successfully."
       		'''
    }
      }
 
        stage('clean workspace') {
            steps{
                 echo "cleaning workspace"
                 deleteDir()  
                 }
       } 

         
   }

}
