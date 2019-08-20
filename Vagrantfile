# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"
  config.vm.synced_folder "D:/var/opt/jfrog/artifactory", "/var/opt/jfrog/artifactory", type: "nfs", group: "1030", owner: "1030"

  # jfrog Server
  config.vm.define "jfrog" do |jfrog|
    jfrog.vm.box = "centos/7"
    jfrog.vm.hostname = "jfrog.example.com"
    jfrog.vm.network "private_network", ip: "172.42.42.100"
    jfrog.vm.provider "virtualbox" do |v|
      v.name = "jfrog"
      v.memory = 3000
      v.cpus = 2
    end
    #jfrog.vm.provision "shell", path: "bootstrap_jfrog.sh"
  end
end