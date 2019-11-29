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

dockerb-jenkins-v2-5-3:
	docker build --force-rm -t rfaguiar/jenkins-as-code:2.5.3 .;

dockerrun-jenkins-v2-5-3: dockerb-jenkins-v2-5-3
	docker run \
	--network minha-rede \
	--hostname jenkins \
	--rm --name jenkins-v2.5.3 \
	-p 8080:8080 \
	-e KUBERNETES_SERVER_URL='http://kubernetes:4433' \
	-e JENKINS_URL='http://jenkins:8080' \
	-e JAVA_OPTS='-Djenkins.install.runSetupWizard=false' \
	-v $(shell pwd)/downloads/:/var/jenkins_home/downloads/ \
   	-v $(shell pwd)/m2deps/:/var/jenkins_home/.m2/repository/ \
	rfaguiar/jenkins-as-code:2.5.3;

dockerl-jenkins-v2-5-3:
	docker logs -f jenkins-v2.5.3;

dockerp-jenkins-v2-5-3:
	docker push rfaguiar/jenkins-as-code:2.5.3;

dockerrm-jenkins-v2-5-3:
	docker container rm -f jenkins-v2.5.3;

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
	eval $$(minikube -p minikube docker-env) && docker build --force-rm -t rfaguiar/jenkins-as-code:2.5.3 . && docker pull cloudbees/java-build-tools:2.0.0;

k-deploy-jenkins:
	kubectl apply -f kubernetes/;

k-delete-jenkins:
	kubectl delete -f kubernetes/;
