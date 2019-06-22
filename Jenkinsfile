def label = "jenkins-slave-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
    containerTemplate(name: 'slave1', image: 'durgaprasad444/allinonecentos:v1', ttyEnabled: true, command: 'cat')
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
                      cp -rf settings.xml settings-security.xml /root/.m2/
                    """
                }
            }
        stage("mvn build") {
            container('slave1') {
                    // If you are using Windows then you should use "bat" step
                    // Since unit testing is out of the scope we skip them
                    sh "mvn deploy -DskipTests=true"
            }
        }
        stage('Build image') {
            container('slave1') {
                sh """
                cd /home/jenkins/workspace/maven-example
                docker build -t kube-cluster/${APP_NAME}-${tag}:$BUILD_NUMBER .
                """
                
  
}
}
stage('Push image') {
    container('slave1') {
  docker.withRegistry('https://gcr.io', 'gcr:gcr_authentication_json_key') {
      sh "docker push kube-cluster/${APP_NAME}-${tag}:$BUILD_NUMBER"
    
    
  }
    }
}

        
        
        
        stage("deploy on kubernetes") {
            container('slave1') {
                sh "kubectl apply -f hello-kubernetes.yaml"
                sh "kubectl set image deployment/maven-example maven-example-sha256=gcr.io/kube-cluster/${APP_NAME}-${tag}:$BUILD_NUMBER"
            }
        }
                }
            }
