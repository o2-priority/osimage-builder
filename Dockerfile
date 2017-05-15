FROM alpine
MAINTAINER "Alan Platt" <aplatt@equalexperts.com>

RUN apk update
RUN apk add wget ca-certificates
RUN wget --no-check-certificate -qO- https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_linux_amd64.zip > tmp.zip
RUN unzip tmp.zip -d /bin && rm tmp.zip
RUN mkdir -p ~/.aws /root/artifact-builder

