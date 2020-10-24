def label = "jenkins-slave-${UUID.randomUUID().toString()}"
podTemplate(label: label, cloud: openshift, containers: [
    containerTemplate(name: 'slave1', image: 'durgaprasad444/jenmine:1.1', ttyEnabled: true, command: 'cat')
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
    node(label) {
        def APP_NAME = "helloworld-cicd"
        def tag = "dev"
            stage("clone code") {
                container('slave1') {
                    
                    // Let's clone the source
                    sh """ 
                      git clone https://github.com/durgaprasad444/${APP_NAME}.git            
                      cd ${APP_NAME}
                      cp -rf * /home/jenkins/workspace/maven-example
                    """
                }
            }
        stage("mvn build") {
            container('slave1') {
                    // If you are using Windows then you should use "bat" step
                    // Since unit testing is out of the scope we skip them
                    sh "mvn package -DskipTests=true"
            }
        }
        

        stage('Build image') {
            container('slave1') {
                sh """
                cd /home/jenkins/workspace/maven-example
                docker build -t gcr.io/sentrifugo/${APP_NAME}-${tag}:$BUILD_NUMBER .
                """
                
  
}
}
stage('Push image') {
    container('slave1') {
  
      sh 'docker login -u my-account -p xxxx'
      sh "docker push docker.io/username/${APP_NAME}-${tag}:$BUILD_NUMBER"
    
    
  
    }
}

        
        
        
        stage("deploy on kubernetes") {
            container('slave1') {
                sh "kubectl apply -f hello-kubernetes.yaml"
                sh "kubectl set image deployment/hello-kubernetes hello-kubernetes=gcr.io/sentrifugo/${APP_NAME}-${tag}:$BUILD_NUMBER"
            }
        }
                }
            }
