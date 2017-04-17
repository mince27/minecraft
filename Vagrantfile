# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'debian/jessie64'
  config.vm.network :forwarded_port, guest: 25_565, host: 25_565
  config.vm.network :private_network, ip: '192.168.10.12'
  config.vm.synced_folder '.', '/vagrant', type: 'nfs'
  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.cpus = '2'
    vb.memory = '4092'
  end

  config.vm.provision 'shell', privileged: true, inline: <<-SHELL
    # This should match what the user_data script does as much as possible
    echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y python-pip screen vim
    apt-get install -t jessie-backports -y openjdk-8-jre-headless ca-certificates-java
    pip install --upgrade awscli
  SHELL
end
