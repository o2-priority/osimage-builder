# -*- mode: ruby -*-
# vi: set ft=ruby :
#\

require 'yaml'

hosts = YAML.load_file('./vagrant_hosts.yaml')['hosts']

Vagrant.configure("2") do |config|
  hosts.each do |name, host|
    config.vm.define name do |host_config|

      host_config.vm.box = "#{host[:role]}-ubuntu-trusty-14.04-amd64-vagrant"
      host_config.vm.hostname = "#{name}.#{host[:role]}.internal"
      host_config.vm.synced_folder ".", "/vagrant"

      host_config.vm.provider "virtualbox" do |vb|
        vb.name = name
        vb.gui = false
        vb.cpus   = 2
        vb.memory = 2048
        #vb.customize [
        #  "modifyvm", :id
        #]

      end
    end
  end
end
