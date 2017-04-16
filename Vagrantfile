# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  server_port = 25_565

  config.vm.box = 'debian/jessie64'
  config.vm.network :forwarded_port, guest: server_port, host: server_port
  config.vm.network :private_network, ip: '192.168.10.12'
  config.vm.synced_folder '.', '/vagrant', type: 'nfs'
  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.cpus = '2'
    vb.memory = '4092'
  end

  config.vm.provision 'shell', privileged: true, inline: <<-SHELL
  SHELL
end
