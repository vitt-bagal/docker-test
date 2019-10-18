# Base image
FROM ecos0003:5000/jenkins_slave_rhel:8.0
# The author
LABEL maintainer="LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)"
ARG VERSION=3.35
ARG user=test
ARG AGENT_WORKDIR=/home/${user}/agent
# Set Environment Variables
ENV HOME /home/${user}
ENV JAVA_HOME=/usr/share/jdk8u222-b10/
ENV PATH=$JAVA_HOME/bin:$PATH
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="${VERSION}"
# Install dependencies
RUN yum install -y tar wget libfontenc-devel curl
# Download AdoptJDK8
RUN wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10_openj9-0.15.1/OpenJDK8U-jdk_s390x_linux_openj9_8u222b10_openj9-0.15.1.tar.gz \
&& tar -C /usr/share/ -xzvf OpenJDK8U-jdk_s390x_linux_openj9_8u222b10_openj9-0.15.1.tar.gz
# Download Jenkins agent.jar
RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
# Download JNLP jenkins agent script
  && curl -o /usr/local/bin/jenkins-agent https://raw.githubusercontent.com/jenkinsci/docker-jnlp-slave/3.35-4/jenkins-agent \
  && chmod 755 /usr/local/bin/jenkins-agent \
  && ln -fs /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}
VOLUME $HOME/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR $HOME
# Run JNLP jenkins agent script
ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
