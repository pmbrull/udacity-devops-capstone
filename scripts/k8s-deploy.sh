#!/bin/bash

echo "Creating the volume..."

kubectl apply -f ./kubernetes/persistent-volume.yaml
kubectl apply -f ./kubernetes/persistent-volume-claim.yaml


echo "Creating the database credentials..."

kubectl apply -f ./kubernetes/postgres-secret.yaml


echo "Creating the postgres deployment and service..."

kubectl create -f ./kubernetes/postgres-deployment.yaml
kubectl create -f ./kubernetes/postgres-service.yaml


echo "Creating the flask deployment and service..."

kubectl create -f ./kubernetes/flask-deployment.yaml
kubectl create -f ./kubernetes/flask-service.yaml


echo "Adding the ingress..."

minikube addons enable ingress
kubectl apply -f ./kubernetes/flask-ingress.yaml