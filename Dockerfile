FROM rfaguiar/jenkins-as-code:0.2.0
USER root
#RUN apt-get update && apt-get install -y make git openjdk-8-jdk
RUN mkdir /srv/backup && chown jenkins:jenkins /srv/backup
USER jenkins
#COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64