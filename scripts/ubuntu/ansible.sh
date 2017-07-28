#!/bin/sh -eux

# Install things required by ansible.

output() {
  echo "$1"
}

output "Update the package list"
apt-get -y update

apt-get install -y python-minimal
