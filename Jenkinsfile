pipeline {
    agent any
    
    environment {
    	DOCKER_IMG_NAME = 'user-service'
    	DOCKER_TMP_CONTAINER_NAME = 'tmp-user-service-container'
    	DOCKER_REPO = 'learnwithvinod'
    }

    stages {
    
        stage('clean') {
            steps {
                sh 'mvn clean' 
            }
        }
        
        stage('compile') {
            steps {
            	echo 'compiling source files...'
                sh 'mvn compile' 
            }
        }
        
        /*
        stage('quality') {
            steps {
                sh 'mvn sonar:sonar' 
            }
        }
        */
                
        stage('unit-test') {
            steps {
            	echo 'running unit tests...'
                sh 'mvn test' 
            }
        }
        
        stage('build') {
            steps {
            	echo 'creating the JAR for the project...'
                sh 'mvn package -DskipTests=true' 
            }
        }
        
        stage('dockerize') {
        	steps {
        		echo 'building the docker image for user-service...'
				sh "docker build -t ${DOCKER_REPO}/${DOCKER_IMG_NAME}:${env.BUILD_ID} ."
				sh "docker tag ${DOCKER_REPO}/${DOCKER_IMG_NAME}:${env.BUILD_ID} ${DOCKER_REPO}/${DOCKER_IMG_NAME}:latest"         	
        	}
        }
        
        stage('integration tests') {
        	steps {
        		echo 'running the tmp-user-service-container for integration testing...'
        		sh "docker run -dp 7070:8080 --rm --name ${DOCKER_TMP_CONTAINER_NAME} ${DOCKER_REPO}/${DOCKER_IMG_NAME}:${env.BUILD_ID}"
        		sleep 30
        		sh 'curl -i http://localhost:7070/api/users'
        	}
        }
        
        stage('docker publish') {
        	steps {
	        	withDockerRegistry([credentialsId: 'docker_creds', url: '']) {
        			sh "docker push ${DOCKER_REPO}/${DOCKER_IMG_NAME}:latest"
        			sh "docker push ${DOCKER_REPO}/${DOCKER_IMG_NAME}:${env.BUILD_ID}"
        		}
        	}
        }
        
    }
    
	post {
	    always {
	    	echo 'stopping and removing the tmp-user-service-container...'
    		sh "docker stop ${DOCKER_TMP_CONTAINER_NAME}"
    		sh "docker rmi ${DOCKER_REPO}/${DOCKER_IMG_NAME}:latest ${DOCKER_REPO}/${DOCKER_IMG_NAME}:${env.BUILD_ID}"
    	}
	}
}











