# defaul shell
SHELL = /bin/bash

# Rule "help"
.PHONY: help
.SILENT: help
help:
	echo "Use make [rule]"
	echo "Rules:"
	echo ""

dockerb-jenkins-v0-2-0:
	docker build --force-rm -t rfaguiar/jenkins-as-code:0.2.0 .;

dockerp-jenkins-v0-2-0:
	docker push rfaguiar/jenkins-as-code:0.2.0;

dockerrun-jenkins-v0-2-0:
	docker run --network minha-rede --hostname jenkins --name jenkins-v0.2.0 -p 8080:8080 rfaguiar/jenkins-as-code:0.2.0;

dockerl-jenkins-v0-2-0:
	docker logs jenkins-v0.2.0;

dockerrm-jenkins-v0-2-0:
	docker container rm -f jenkins-v0.2.0;