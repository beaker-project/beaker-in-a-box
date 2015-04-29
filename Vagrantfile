# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "centos-6"
  config.vm.box_url = "https://download.gluster.org/pub/gluster/purpleidea/vagrant/centos-6/centos-6.box"

  config.vm.define 'beaker-server-lc' do |server|
    server.vm.hostname = 'beaker-server-lc.beaker'
    server.ssh.username = 'root'
    server.ssh.password = 'vagrant'
    server.vm.network "private_network", libvirt__network_name: "beaker",
                      mac: "52:54:00:c6:73:4f"
    # disable the default synced folder
    server.vm.synced_folder ".", "/vagrant", disabled: true
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
