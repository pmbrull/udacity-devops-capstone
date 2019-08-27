pipeline {
  agent any
  stages {
    stage('Lint files') {
      steps {
        sh 'make lint'
      }
    }
    stage('Build Docker') {
      steps {
        sh 'make build'
      }
    }
    stage('login to dockerhub') {
      withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhubpwd')]) {
        sh 'docker login -u pmbrull -p ${dockerhubpwd}'
      }
    }
    stage('Deploy Kubernetes') {
      sh 'kubectl apply -f ./kubernetes'
    }
  }
}