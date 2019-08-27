pipeline {
  agent any
  stages {
    stage('setup and lint') {
      steps {
        sh """
           echo ${SHELL}
           [ -d venv ] && rm -rf venv
           virtualenv venv
           . venv/bin/activate
           export PATH=${VIRTUAL_ENV}/bin:${PATH}
           pip install --upgrade pip
           pip install -r requirements.txt
           make lint
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