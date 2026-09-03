# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  # VM Jenkins
  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.hostname = "jenkins"
    jenkins.vm.network "private_network", ip: "192.168.56.10"
    jenkins.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 2
    end
    jenkins.vm.provision "shell", path: "scripts/jenkins.sh"
  end

  # VM Produção
  config.vm.define "prod" do |prod|
    prod.vm.hostname = "prod"
    prod.vm.network "private_network", ip: "192.168.56.20"
    prod.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
    prod.vm.synced_folder "./app", "/app", create: true
    prod.vm.provision "shell", path: "scripts/prod.sh"
  end

  # Provisionamento comum
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y curl wget git vim
  SHELL

  # Configuração SSH (opcional)
  config.vm.provision "shell", inline: <<-SHELL
    if [[ "$(hostname)" == "jenkins" ]]; then
      sudo -u vagrant ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa
      echo ">>> Chave SSH gerada no jenkins."
      echo ">>> Para copiar para a prod, execute: ssh-copy-id vagrant@192.168.56.20"
    fi
  SHELL
end
