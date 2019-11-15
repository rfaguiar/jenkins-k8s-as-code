# defaul shell
SHELL = /bin/bash

# Rule "help"
.PHONY: help
.SILENT: help
help:
	echo "Use make [rule]"
	echo "Rules:"
	echo ""

dockerb-jenkins-v2-0-2:
	docker build --force-rm -t rfaguiar/jenkins-as-code:2.0.2 .;

dockerrun-jenkins-v2-0-2: dockerb-jenkins-v2-0-2
	docker run \
	--network minha-rede \
	--hostname jenkins \
	--rm --name jenkins-v2.0.2 \
	-p 8080:8080 \
	-v ${pwd}/downloads:/var/jenkins_home/downloads \
    -v ${pwd}/m2deps:/var/jenkins_home/.m2/repository/ \
	rfaguiar/jenkins-as-code:2.0.2;

dockerl-jenkins-v2-0-2:
	docker logs -f jenkins-v2.0.2;

dockerp-jenkins-v2-0-2:
	docker push rfaguiar/jenkins-as-code:2.0.2;

dockerrm-jenkins-v2-0-2:
	docker container rm -f jenkins-v2.0.2;

dockersetupandrun:
	sh ./setup-and-run.sh;
