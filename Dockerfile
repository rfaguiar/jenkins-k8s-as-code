FROM jenkins/jenkins:2.196
LABEL description="this use jenkins base version 2.196 and instaled last versions pluguins and custom configs"
ARG master_image_version="v2.0.2"
ENV master_image_version $master_image_version

USER jenkins
RUN echo 2.196 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
RUN echo 2.196 > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion
# Plugin Setup
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
# Auto Configuration Scripts
COPY .ssh/.password /var/jenkins_home/.ssh/
COPY src/main/groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY src/main/resources/* ${JENKINS_HOME}/config/