#!/bin/sh -eux

# Install things required by ansible.

output() {
  echo "$1"
}

output "Update the package list"
apt-get -y update

output "Add ansible apt repository"
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get -y update

output "Install ansible pip package"
apt-get install -y python-minimal python-pip ansible
