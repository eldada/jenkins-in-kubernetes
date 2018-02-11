FROM jenkins/jenkins:lts

# A default admin user
ENV ADMIN_USER=admin \
    ADMIN_PASSWORD=password

# Install plugins at Docker image build time
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt) && \
    mkdir -p /usr/share/jenkins/ref/ && \
    echo lts > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state && \
    echo lts > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

# Jenkins init scripts
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/

# Install Docker (as root)
USER root
RUN apt-get -qq update && \
    apt-get -qq -y install curl && \
    curl -sSL https://get.docker.com/ | sh

# Allow jenkins user to run docker
RUN usermod -a -G staff,docker jenkins

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Switch back to user jenkins
USER jenkins
