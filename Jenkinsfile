pipeline {
    agent any 
    
    environment{
        PROD_IP='18.212.53.21'
        DHUB_IMAGE='web-app'
        DHUB_REPO='ethanman399/web-app'
    }
    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    def scmGitVars = checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-credentials', url: 'https://github.com/ethanman399/CW02.git']])
                
                    echo scmGitVars.GIT_COMMIT.substring(5, 10)
                    env.DHUB_TAG = scmGitVars.GIT_COMMIT.substring(5, 10)
                }
            }
        }
        
        stage('Docker Build'){
            steps{
                script{
                    sh 'docker image build --tag ${DHUB_REPO}:${DHUB_TAG} .'
                }
            }
        }
        
        stage('Docker Test'){
            steps{
                script{
                    def echo_out = sh(script: "docker run --rm ${DHUB_REPO}:${DHUB_TAG} echo This is a test.", returnStdout: true).trim()
                    echo "${echo_out}"
                }
            }
        }
        
        stage('DockerHub Push'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'dockerhub_pass', usernameVariable: 'dockerhub_user')]) {
                        sh "docker login -u ${dockerhub_user} -p ${dockerhub_pass}"
                        sh "docker image push ${dockerhub_user}/${DHUB_IMAGE}:${DHUB_TAG}"
                    }
                }
            }
        }
        
        stage('Deploy to Prod Server'){
            steps{
                    sshagent(['ssh-key']) {
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@${PROD_IP} kubectl set image deployment/${DHUB_IMAGE} ${DHUB_IMAGE}=${DHUB_REPO}:${DHUB_TAG}'
            }
            }
        }
    }
}
