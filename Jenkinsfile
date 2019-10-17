node('docker-jnlp') {
    String exceptionMessage
try{
    stage('Checkout'){
		git url: 'https://github.com/vitt-bagal/docker-test'
    }
	
    stage('Build Docker Image'){
		echo 'Starting to build docker image'
		sh 'docker build -t ecos0003:5000/jenkins_slave_rhel:7.5 .'
    }
	
    stage('Verify Docker Image'){
		echo 'Starting to verify docker image'
		script {
			sh '''
			docker run -d --name rh7.4_container ecos0003:5000/jenkins_jnlpslave_rhel:7.6 -url http://9.98.173.181:8081 8de5806d7a030b157c66c51bde66f0aba2ab5956ba3f674d4698e6d11b117821  rh7.4-snehal
			sleep 2m
			docker logs rh7.4_container |& tee container_log 
			if grep "INFO: Connected" container_log 
			then
				exit 0
			else
				exit 1
			fi
			'''
		}
    }
    stage('Push Docker Image'){
		echo 'Starting to Push docker image'
		sh 'docker push ecos0003:5000/jenkins_slave_rhel:7.5'
    }
	}	
catch (Exception e) {
    exceptionMessage = e.getMessage()
    throw e
}
}

