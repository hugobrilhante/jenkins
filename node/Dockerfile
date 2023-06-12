# syntax=docker/dockerfile:1
FROM jenkins/ssh-agent

ARG SSH_PUBLIC_KEY

ENV JENKINS_AGENT_SSH_PUBKEY $SSH_PUBLIC_KEY

# Copy ssh configs
COPY --chown=jenkins:jenkins ./ssh $JENKINS_AGENT_HOME/.ssh