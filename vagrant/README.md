# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_MASTER_NODE = 1
NUM_WORKER_NODE = 1

IP_NW = "192.168.56."
MASTER_IP_START = 10
NODE_IP_START = 20

# Sets up hosts file and DNS
def setup_dns(node)
  # Set up /etc/hosts
  node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
    s.args = ["enp0s8", node.vm.hostname]
  end
  # Set up DNS resolution
  node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
end

# Runs provisioning steps that are required by masters and workers
def provision_kubernetes_node(node)
  # Set up kernel parameters, modules and tunables
  node.vm.provision "setup-kernel", :type => "shell", :path => "ubuntu/setup-kernel.sh"
  # Restart
  node.vm.provision :shell do |shell|
    shell.privileged = true
    shell.inline = "echo Rebooting"
    shell.reboot = true
  end
  # Set up DNS
  setup_dns node
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "base"
  config.vm.box = "ubuntu/focal64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Provision Master Nodes
  (1..NUM_MASTER_NODE).each do |i|
    config.vm.define "master-#{i}" do |node|
      # Name shown in the GUI
      node.vm.provider "virtualbox" do |vb|
        vb.name = "kubernetes-ha-master-#{i}"
        if i == 1
          vb.memory = 2048    # More needed to run e2e tests at end
        else
          vb.memory = 1024
        end
        vb.cpus = 2
      end
      node.vm.hostname = "master-#{i}"
      node.vm.network :private_network, ip: IP_NW + "#{MASTER_IP_START + i}"
      node.vm.network "forwarded_port", guest: 22, host: "#{2710 + i}"
      provision_kubernetes_node node
      if i == 1
        # Install (opinionated) configs for vim and tmux on master-1. These used by the author for CKA exam.
        node.vm.provision "file", source: "./ubuntu/tmux.conf", destination: "$HOME/.
