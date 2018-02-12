# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.22.22"

  config.vm.synced_folder "./", "/opt/provisioning"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = "2048"
    vb.cpus = 2
  end

  # Install needed tools
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get -qq -y install curl jq
    
    # Install Docker
    curl -sSL https://get.docker.com/ | sh
    service docker start

    usermod -aG docker ubuntu
  SHELL
end
