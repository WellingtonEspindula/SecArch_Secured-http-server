Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"
    config.vm.host_name = "ernestometric"
    
    config.vm.network "public_network"
  
    config.vm.provider "virtualbox" do |vb|
       vb.memory = "4096"
       vb.cpus = "2"
    end
  

    # Users Passwords
    vagrant_password      = "fHqdurq9nT"
    user1_name            = "user1"
    user1_password        = "Str0ngPassword1"
    user2_name            = "user2"
    user2_password        = "Str0ngPassword2"
    user2_name            = "user3"
    user3_password        = "Str0ngPassword3"


    config.vm.provision "shell", inline: <<-SHELL
    
    # Create new user and group
    sudo useradd -m -s /bin/bash -U user1 -p paV/D3AVahtYk
    echo "user1:$(echo '#{user1_password}' | openssl passwd -1 -stdin)" | chpasswd -e
    
    # Create new user and group
    sudo useradd -m -s /bin/bash -U user2 -p paV/D3AVahtYk
    echo "user2:$(echo '#{user2_password}' | openssl passwd -1 -stdin)" | chpasswd -e
     
    # Create new user and group
    sudo useradd -m -s /bin/bash -U user3 -p paV/D3AVahtYk
    echo "user3:$(echo '#{user3_password}' | openssl passwd -1 -stdin)" | chpasswd -e

    # Join user3 to group user1 and user2  
    sudo usermod -aG user1 user3
    sudo usermod -aG user2 user3

    # Update repo 
    sudo apt update

    # Network policies
    sudo apt install net-tools ufw 
    sudo route del default gw 10.0.2.2 enp0s3

    # Firewall allowing 22 and 8080 (ssh and http)
    sudo ufw enable 
    sudo ufw allow 22
    sudo ufw allow 8080

    # Ngnix install and config
    sudo apt install -y ngnix


    SHELL

    config.vm.provision :reload
   
    # default router
    config.vm.provision "shell",
      run: "always",
      inline: "ip route del default via 10.0.2.2 || true"

    config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "0.0.0.0"
    config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "0.0.0.0"

   end

