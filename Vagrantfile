# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box = "centos/7"
  config.vm.provider "hyperv"
  config.vm.network "public_network"
  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", host_ip: "127.0.0.1"

  config.vm.provider "hyperv" do |h|
    h.cpus = 2
    h.memory = 2048
    h.enable_virtualization_extensions = true
    h.differencing_disk = true
  end

  config.vm.provider "hyperv" do |h|
  h.vm_integration_services = {
      guest_service_interface: true,
      heartbeat: true,
      key_value_pair_exchange: true,
      shutdown: true,
      time_synchronization: true,
      vss: true
  }
  end

  #config.vm.synced_folder ".", "/vagrant"
  #config.vm.synced_folder "../data", "/vagrant_data"
  #config.vm.synced_folder "../www", "/var/www"
  config.vm.provision :shell, path: "./bootstrap.sh"

end
