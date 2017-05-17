#!/bin/sh -eux

ubuntu_version="`lsb_release -r | awk '{print $2}'`"
ubuntu_major_version="`echo $ubuntu_version | awk -F. '{print $1}'`"

# Disable release-upgrades
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

# Update the package list
apt-get -y update

# update package index on boot
cat << EOF > /etc/init/refresh-apt.conf
description "update package index"
start on networking
task
exec /usr/bin/apt-get update
EOF

# Disable periodic activities of apt
cat << EOF > /etc/apt/apt.conf.d/10disable-periodic
APT::Periodic::Enable "0";
EOF

#Add GPG signing key for ubuntu repos
apt-key adv --keyserver keyserver.ubuntu.com --recv 1E9377A2BA9EF27F

# Upgrade all installed packages incl. kernel and kernel headers
export DEBIAN_FRONTEND=noninteractive
apt-get dist-upgrade -y -o Dpkg::Options::="--force-confnew"
reboot
sleep 60
