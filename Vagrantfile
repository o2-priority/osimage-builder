# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "base-ubuntu-trusty-14.04-amd64-vagrant"
  config.vm.synced_folder "/tmp", "/vagrant"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end
end
