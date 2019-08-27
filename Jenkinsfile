pipeline {
  agent { docker { image 'python:3.7.3' } }
  stages {
    stage('install') {
      steps {
        sh 'make install'
      }
    }
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