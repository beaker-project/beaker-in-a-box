# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "centos-6"
  config.vm.box_url = "https://download.gluster.org/pub/gluster/purpleidea/vagrant/centos-6/centos-6.box"

  # create beaker server and testing systems
  test_systems = [
    { :hostname => 'beaker-test-vm1', :ip => '192.168.120.105', :mac => '52:54:00:c6:71:8e' },
    { :hostname => 'beaker-test-vm2', :ip => '192.168.120.106', :mac => '52:54:00:c6:71:8f' },  
    { :hostname => 'beaker-test-vm3', :ip => '192.168.120.107', :mac => '52:54:00:c6:71:90' },
  ]
  test_systems.each do |system|
    config.vm.define system[:hostname] do |machine|
      machine.vm.host_name = system[:hostname]
      machine.vm.network "private_network", libvirt__network_name: "beaker",
                         ip: system[:name], mac: system[:mac], model_type: "virtio"
      machine.vm.provider :libvirt do |v|
        v.driver = 'kvm'
        v.memory = 2048
        v.graphics_port = '-1'
      end
    end
  end
  config.vm.define 'beaker-server-lc' do |server|
    server.vm.hostname = 'beaker-server-lc.beaker'
    server.ssh.username = 'root'
    server.ssh.password = 'vagrant'
    server.vm.network "private_network", libvirt__network_name: "beaker",
                      ip: "192.168.120.104", mac: "52:54:00:c6:73:4f"
    server.vm.provider :libvirt do |v|
        v.driver = 'kvm'
        v.memory = 2048
        v.cpus = 2
    end
    server.vm.provision "ansible" do |ansible|
      ansible.playbook="setup_beaker.yml"
    end
  end

end
