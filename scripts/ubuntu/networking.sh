#!/bin/sh -eux

ubuntu_version="`lsb_release -r | awk '{print $2}'`"
major_version="`echo $ubuntu_version | awk -F. '{print $1}'`"

###disable ipv6  (Why disable ipv6?)
##
##cat >> /etc/sysctl.conf << EOF
##
##net.ipv6.conf.all.disable_ipv6 = 1
##net.ipv6.conf.default.disable_ipv6 = 1
##net.ipv6.conf.lo.disable_ipv6 = 1
##
##EOF

if [ "$major_version" -le "16" ]; then
  echo "Disabling automatic udev rules for network interfaces in Ubuntu"
  # Disable automatic udev rules for network interfaces in Ubuntu,
  # source: http://6.ptmc.org/164/
  rm -vf /etc/udev/rules.d/70-persistent-net.rules
  #mkdir -vp /etc/udev/rules.d/70-persistent-net.rules
  rm -vf /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -vrf /dev/.udev/ /var/lib/dhcp3/* /var/lib/dhcp/*
fi
