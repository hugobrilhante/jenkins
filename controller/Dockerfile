# syntax=docker/dockerfile:1
FROM jenkins/jenkins:lts

USER jenkins

ARG SSH_PRIVATE_KEY

ARG SSH_KEY_PASSWORD

ENV SSH_PRIVATE_KEY $SSH_PRIVATE_KEY

ENV SSH_KEY_PASSWORD $SSH_KEY_PASSWORD

# Configuration as code plugin
COPY --chown=jenkins:jenkins ./controller/jenkins.yaml "${JENKINS_HOME}"/jenkins.yaml

# Install https://plugins.jenkins.io/
# To install plugins at build time add the plugins line by line in the plugins.txt file
# For more information: https://github.com/jenkinsci/docker/blob/master/README.md#preinstalling-plugins
COPY --chown=jenkins:jenkins ./controller/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# Copy ssh configs
COPY --chown=jenkins:jenkins ./ssh $JENKINS_HOME/.ssh