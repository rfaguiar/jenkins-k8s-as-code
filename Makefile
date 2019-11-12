# defaul shell
SHELL = /bin/bash

# Rule "help"
.PHONY: help
.SILENT: help
help:
	echo "Use make [rule]"
	echo "Rules:"
	echo ""

dockerb-jenkins-v0-3-0:
	docker build --force-rm -t rfaguiar/jenkins-as-code:0.3.0 .;

dockerp-jenkins-v0-3-0:
	docker push rfaguiar/jenkins-as-code:0.3.0;

dockerrun-jenkins-v0-3-0:
	docker run --network minha-rede \
	--hostname jenkins \
	--name jenkins-v0.3.0 \
	-p 8080:8080 \
	-v pwdjenkins_home_3:/var/jenkins_home \
	-v jenkins_backup_3:/srv/backup \
	rfaguiar/jenkins-as-code:0.3.0;

dockerl-jenkins-v0-3-0:
	docker logs jenkins-v0.3.0;

dockerrm-jenkins-v0-3-0:
	docker container rm -f jenkins-v0.3.0;