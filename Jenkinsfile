pipeline {
  agent any
  environment {
    VIRTUAL_ENV = "${env.WORKSPACE}/venv"
  }
  stages {
    stage('setup and lint') {
      steps {
        sh """
           echo '${PATH}'
           hadolint Dockerfile
           """
      }
    }
    stage('Build Docker') {
      steps {
        sh 'make build'
      }
    }
    stage('login to dockerhub') {
      steps {
        withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhubpwd')]) {
          sh 'docker login -u pmbrull -p ${dockerhubpwd}'
        }
      }
    }
    stage('Deploy Kubernetes') {
      steps {
        sh 'kubectl apply -f ./kubernetes'
      }
    }
  }
}