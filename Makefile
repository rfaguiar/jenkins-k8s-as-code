# defaul shell
SHELL = /bin/bash

# Rule "help"
.PHONY: help
.SILENT: help
help:
	echo "Use make [rule]"
	echo "Rules:"
	echo ""

dockerb-jenkins-v1-0-0:
	docker build --force-rm -t rfaguiar/jenkins-as-code:1.0.0 .;

dockerp-jenkins-v1-0-0:
	docker push rfaguiar/jenkins-as-code:1.0.0;

dockerrun-jenkins-v1-0-0:
	docker run -d \
	--network minha-rede \
	--hostname jenkins \
	--name jenkins-v1.0.0 \
	-p 8080:8080 \
	-v pwdjenkins_home_100:/var/jenkins_home \
	-v jenkins_backup_100:/srv/backup \
	rfaguiar/jenkins-as-code:1.0.0;

dockerl-jenkins-v1-0-0:
	docker logs -f jenkins-v1.0.0;

dockerrm-jenkins-v1-0-0:
	docker container rm -f jenkins-v1.0.0;
