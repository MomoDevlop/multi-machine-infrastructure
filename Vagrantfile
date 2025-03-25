Vagrant.configure("2") do |config|
  # Load Balancer
  config.vm.define "lb" do |lb|
    lb.vm.box = "ubuntu/bionic64"
    lb.vm.network "private_network", ip: "192.168.56.10"
    lb.vm.provision "shell", path: "scripts/setup_lb.sh"
    lb.vm.network "forwarded_port", guest: 80, host: 8083
    lb.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end
  end

  # Web Server 1
  config.vm.define "web1" do |web1|
    web1.vm.box = "ubuntu/bionic64"
    web1.vm.network "private_network", ip: "192.168.56.11"
    web1.vm.network "forwarded_port", guest: 80, host: 8081
    web1.vm.provision "shell", path: "scripts/setup_web.sh"
    web1.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end
  end

  # Web Server 2
  config.vm.define "web2" do |web2|
    web2.vm.box = "ubuntu/bionic64"
    web2.vm.network "private_network", ip: "192.168.56.12"
    web2.vm.network "forwarded_port", guest: 80, host: 8082
    web2.vm.provision "shell", path: "scripts/setup_web.sh"
    web2.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end
  end

  # Database Master
  config.vm.define "db-master" do |db_master|
    db_master.vm.box = "ubuntu/bionic64"
    db_master.vm.network "private_network", ip: "192.168.56.13"
    db_master.vm.provision "shell", path: "scripts/setup_db_master.sh"
    db_master.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end
  end

  # Database Slave
  config.vm.define "db-slave" do |db_slave|
    db_slave.vm.box = "ubuntu/bionic64"
    db_slave.vm.network "private_network", ip: "192.168.56.14"
    db_slave.vm.provision "shell", path: "scripts/setup_db_slave.sh"
    db_slave.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end
  end

  # Monitoring Server
  config.vm.define "monitoring" do |monitoring|
    monitoring.vm.box = "ubuntu/bionic64"
    monitoring.vm.network "private_network", ip: "192.168.56.15"
    monitoring.vm.provision "shell", path: "scripts/setup_monitoring.sh"
    monitoring.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end
  end

  # Client Machine
  config.vm.define "client" do |client|
    client.vm.box = "ubuntu/bionic64"
    client.vm.network "private_network", ip: "192.168.56.16"
    client.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = 1
    end
  end
end