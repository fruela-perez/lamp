# # -*- mode: ruby -*-
# # vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_check_update = false
  config.vm.hostname = "lamp"

  config.vm.network "forwarded_port", guest:   80, host: 8080      
  config.vm.network "forwarded_port", guest:  443, host: 8443 
  config.vm.network "forwarded_port", guest: 3306, host: 33306
 
  config.vm.synced_folder "data/", "/vagrant_data"
  config.vm.synced_folder "webroot", "/var/www/html"   

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.name = "lamp"  
    vb.memory = "2048"                               
  end

  config.vm.provision :shell, path: "./provision/lamp.sh"  

end