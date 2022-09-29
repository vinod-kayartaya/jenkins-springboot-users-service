pipeline {
    agent any

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
				sh 'docker build -t user-service:latest .'        	
        	}
        }
        
        stage('integration tests') {
        	steps {
        		echo 'running the tmp-user-service-container for integration testing...'
        		sh 'docker run -dp 7070:8080 --rm --name tmp-user-service-container user-service:latest'
        		sleep 30
        		sh 'curl -i http://localhost:7070/api/users'
        	}
        }
        
    }
    
	post {
	    always {
	    	echo 'stopping and removing the tmp-user-service-container...'
    		sh 'docker stop tmp-user-service-container'
    	}
	}
}











