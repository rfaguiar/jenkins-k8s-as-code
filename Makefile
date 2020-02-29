# defaul shell
SHELL = /bin/bash
PWD = ${pwd}

# Rule "help"
.PHONY: help
.SILENT: help
help:
	echo "Use make [rule]"
	echo "Rules:"
	echo ""

dockerb-jenkins-master-v2-6-5:
	docker build --force-rm -t rfaguiar/jenkins-as-code:2.6.5 .;

dockerb-jenkins-slave-v1-3-0:
	docker build --force-rm -t rfaguiar/jenkins-slave:1.3.0 ./slave/;

dockerrun-jenkins-master-v2-6-5: dockerb-jenkins-master-v2-6-5
	docker run \
	--network minha-rede \
	--hostname jenkins \
	--rm --name jenkins-v2.6.5 \
	-p 8080:8080 \
	-e KUBERNETES_SERVER_URL='http://kubernetes:4433' \
	-e JENKINS_URL='http://jenkins:8080' \
	-e JAVA_OPTS='-Djenkins.install.runSetupWizard=false' \
	-v $(shell pwd)/jenkins_home:/var/jenkins_home \
	rfaguiar/jenkins-as-code:2.6.5;

dockerrmi-jenkins-master-v2-6-5:
    docker image rmi rfaguiar/jenkins-as-code:2.6.5;

dockerl-jenkins-master-v2-6-5:
	docker logs -f jenkins-v2.6.5;

dockerp-jenkins-master-v2-6-5:
	docker push rfaguiar/jenkins-as-code:2.6.5;

dockerp-jenkins-slave-v1-3-0:
	docker push rfaguiar/jenkins-slave:1.3.0;

dockerrm-jenkins-master-v2-6-5:
	docker container rm -f jenkins-v2.6.5;

dockersetupandrun:
	sh ./setup-and-run.sh;

k-setup:
	minikube -p minikube start --cpus 2 --memory=8192; \
	minikube -p minikube addons enable ingress; \
	minikube -p minikube addons enable metrics-server; \
	kubectl config set-context $$(kubectl config current-context) --namespace=default;

k-dashboard:
	minikube -p minikube dashboard;

k-start:
	minikube start; \
	kubectl config set-context $$(kubectl config current-context) --namespace=default;

k-ip:
	minikube -p minikube ip

k-stop:
	minikube -p minikube stop;

ku-watch:
	kubectl get pods -o wide -w;

# eval $(minikube -p minikube docker-env)
k-build-jenkins:
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t rfaguiar/jenkins-as-code:2.6.5 . && docker pull cloudbees/java-build-tools:2.0.0;

k-deploy-jenkins:
	kubectl apply -f kubernetes/;

k-delete-jenkins:
	kubectl delete -f kubernetes/;
