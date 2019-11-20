FROM jenkins/jenkins:2.196
LABEL description="this use jenkins base version 2.196 and instaled last versions pluguins and custom configs"
ARG master_image_version="v2.0.2"
ENV master_image_version $master_image_version

ENV KUBERNETES_SERVER_URL "http://kubernetes:8443"
ENV JENKINS_SERVER_URL "http://jenkins:8080"

USER jenkins
# Futuramente deixe estes downloads a criterio de seu gerenciador de artefatos
COPY downloads/*.tar.gz /var/jenkins_home/downloads/

# Plugins Install
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Auto Setup Scripts
COPY src/main/groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY src/main/resources/*.properties /var/jenkins_home/config/
COPY src/main/resources/initials/*.file /var/jenkins_home/config/initials/

# Para configuracoes de Seguranca
COPY .ssh/* /var/jenkins_home/.ssh/

#skip wizard
RUN echo 2.196 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
RUN echo 2.196 > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion