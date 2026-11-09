#!bin/sh

set -e

docker build -t lab-app:v1 .

docker run -d --name temp-test -p 8080:80 labb-app:v1

kind load docker-image lab-app:v1 --name lab-cluster

kubectl apply -f deployment.yml

kubectl apply -f service.yml

docker ps

kubectl get pods -o wide

kubect get svc 

kubeclt get deployments

docker rm -f temp-test