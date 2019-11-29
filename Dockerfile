FROM jenkins/jenkins:2.196
LABEL description="this use jenkins base version 2.196 and instaled last versions pluguins and custom configs"

ARG master_image_version="v.2.6.0"
ENV master_image_version $master_image_version

USER jenkins

# Plugins Install
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Auto Setup Scripts
COPY src/main/groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY src/main/resources/*.properties /var/jenkins_home/config/
COPY src/main/resources/initials/*.file /var/jenkins_home/config/initials/

# Para configuracoes de Seguranca
COPY .ssh/* /var/jenkins_home/.ssh/
