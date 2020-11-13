
def label = "jenkins-slave-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
    containerTemplate(name: 'slave', image: 'durgaprasad444/jenmine-slave:v2', ttyEnabled: true, command: 'cat')
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
    node(label) {
        def APP_NAME = "helloworld-cicd"
        def tag = "dev"
            stage("CLONE CODE") {
                container('slave') {
                    
  checkout([$class: 'GitSCM',
        branches: [[name: '*/release/test']],
        doGenerateSubmoduleConfigurations: false,
        extensions: [],
        submoduleCfg: [],
        userRemoteConfigs: [[
            url: 'https://github.com/durgaprasad444/helloworld-cicd.git'
    ]]])
                    
                    // Let's clone the source
                    
                    sh """ 
                   
                      #git clone https://github.com/durgaprasad444/${APP_NAME}.git            
                      cd /home/jenkins/agent/workspace/helloworld-cicd/qa_pipeline
                    """
                }
            }
        stage("MAVEN BUILD") {
            container('slave') {
                    // If you are using Windows then you should use "bat" step
                    // Since unit testing is out of the scope we skip them
                    sh "mvn clean install"
            }
        }
        

        stage('BUILD IMAGE') {
            container('slave') {
                sh """
                cd /home/jenkins/agent/workspace/helloworld-cicd/qa_pipeline
                docker build -t durgaprasad444/${APP_NAME}-${tag}:$BUILD_NUMBER .
                """
                
  
}
}
    stage('PUSH IMAGE') {
                 container('slave') {
                 withCredentials([[$class: 'UsernamePasswordMultiBinding',
                credentialsId: 'dockerhub',
                usernameVariable: 'DOCKER_HUB_USER',
                passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
                 sh "docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}"
                 sh "docker push durgaprasad444/${APP_NAME}-${tag}:$BUILD_NUMBER"
    
    
            }
             }
            }
        
        
        
        stage("DEPLOY ON KUBERNETES") {
            container('slave') {
                sh "cd /home/jenkins/agent/workspace/helloworld-cicd/qa_pipeline"
                sh "kubectl apply -f hello-kubernetes.yaml"
                sh "kubectl set image deployment/hello-kubernetes hello-kubernetes=durgaprasad444/${APP_NAME}-${tag}:$BUILD_NUMBER"
            }
        }
                }
            }
