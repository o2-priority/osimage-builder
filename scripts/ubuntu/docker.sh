#!/bin/sh -eux

output() {
  echo "$1"
}

output "Update the package list"
apt-get -y update

output "Install packages to allow apt to use a repository over HTTPS and other dependancies"
apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  python-pip

output "Add Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88

output "Set up the docker-ce stable repository"
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

output "Update the package list"
apt-get -y update

output "Install docker CE"
apt-get -y install docker-ce

output "Install docker compose"
pip install --upgrade pip docker-compose
