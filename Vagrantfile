Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"
    config.vm.host_name = "Cysec-WellingtonMachadoDeEspindula"

    config.vm.network "public_network", ip: "152.77.84.78"

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

    # Firewall allowing 22 and 80 (ssh and http)
    sudo ufw enable 
    sudo ufw allow from any to 10.0.2.2 port 22 proto tcp
    sudo ufw allow 80

    # Ngnix install and config
    sudo apt install -y nginx

    ip a
    curl localhost:80
    SHELL

    # default router
    config.vm.provision "shell",
      run: "always",
      inline: "ip route del default via 10.0.2.2 || true"

    config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "0.0.0.0"
    config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "0.0.0.0"

end

