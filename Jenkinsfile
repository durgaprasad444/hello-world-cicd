def label = "docker-slave-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
    containerTemplate(name: 'docker', image: 'durgaprasad444/jenmine:1.1', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'slave2', image: 'gcr.io/sentrifugo/jenkins-slave:v2', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.8.8', ttyEnabled: true, command: 'cat')
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
    node(label) {
        def APP_NAME = "hello-world"
        def tag = "dev"
            stage("clone code") {
                container('docker') {
                    
                    // Let's clone the source
                    sh """ 
                      git clone https://github.com/durgaprasad444/${APP_NAME}.git            
                      cd ${APP_NAME}
                      cp -r * /home/jenkins/workspace/maven-example
                    """
                }
            }
        stage("mvn build") {
            container('docker') {
                    // If you are using Windows then you should use "bat" step
                    // Since unit testing is out of the scope we skip them
                    sh "mvn package -DskipTests=true"
            }
        }
        stage('Build image') {
            container('docker') {
                sh """
                cd /home/jenkins/workspace/maven-example
                docker build -t gcr.io/sentrifugo/${APP_NAME}-${tag}:$BUILD_NUMBER .
                """
                
  
}
}
stage('Push image') {
    container('slave2') {
  docker.withRegistry('https://gcr.io', 'gcr:sentrifugo') {
      sh "docker push gcr.io/sentrifugo/${APP_NAME}-${tag}:$BUILD_NUMBER"
    
    
  }
    }
}

        
        stage("publish to nexus") {
            container('docker') {
def pom = readMavenPom file: 'pom.xml'
 nexusPublisher nexusInstanceId: 'localNexus', \
  nexusRepositoryId: 'hello-world', \
  packages: [[$class: 'MavenPackage', \
  mavenAssetList: [[classifier: '', extension: '', \
  filePath: "target/${pom.artifactId}-${pom.version}.${pom.packaging}"]], \
  mavenCoordinate: [artifactId: "${pom.artifactId}", \
  groupId: "${pom.groupId}", \
  packaging: "${pom.packaging}", \
  version: "${pom.version}"]]]
}
        }
        stage("deploy on kubernetes") {
            container('kubectl') {
                sh "kubectl set image deployment/maven-example maven-example-sha256=gcr.io/sentrifugo/${APP_NAME}-${tag}:$BUILD_NUMBER"
            }
        }
                }
            }
        
    
    



   
