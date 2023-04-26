# Base image
FROM python:3.8-alpine 

ENV ANSIBLE_VERSION=6.7.0

ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=
ENV AWS_DEFAULT_REGION=eu-west-1
ENV AWS_PAGER=

RUN apk add --no-cache --virtual=.build-deps libffi-dev openssl-dev build-base && \
    apk add --no-cache --virtual=.run-deps openssh-client ca-certificates openssl && \
    pip install --no-cache-dir cffi==1.14.3 ansible==$ANSIBLE_VERSION && \
    apk del .build-deps && \
    ln -s /usr/local/bin/python /usr/bin/python

ENV AWS_VERSION=1.27
ENV TERRAFORM_VERSION=1.4.0

RUN apk --no-cache add bash groff curl jq ca-certificates git openssl ncurses unzip wget
RUN pip install --no-cache-dir awscli==$AWS_VERSION && \
    wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip && \
    unzip terraform_"$TERRAFORM_VERSION"_linux_amd64.zip -d /usr/bin && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \ 
    curl -LO https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx && \
    curl -LO https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens && \
    chmod +x ./kube* && mv ./kube* /usr/local/bin/ && \
    rm -rf /tmp/* terraform_"$TERRAFORM_VERSION"_linux_amd64.zip && rm -rf /var/cache/apk/* && rm -rf /var/tmp/*

ENV PACKER_VERSION=1.8.6

RUN wget https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_"$PACKER_VERSION"_linux_amd64.zip && \
    unzip packer_"$PACKER_VERSION"_linux_amd64.zip -d /usr/bin && \
    rm -rf packer_*.zip

ENV HELM_VERSION=3.11.3

RUN wget https://get.helm.sh/helm-v"$HELM_VERSION"-linux-amd64.tar.gz && \
    tar -xf helm-v"$HELM_VERSION"-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64/helm helm-v"$HELM_VERSION"-linux-amd64.tar.gz

ENV DOCKER_VERSION=20.10.24

RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz \
    && tar -xf docker-$DOCKER_VERSION.tgz \
    && rm -rf docker-$DOCKER_VERSION.tgz \
    && mv docker/* /usr/local/bin/ \
    && rm -rf docker

ENV PS1 "\h > "
CMD ["/bin/bash"]
