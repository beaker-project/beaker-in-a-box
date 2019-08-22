# Beaker in a box
Beaker in a box provides a way of using Ansible to install and configure a complete working Beaker environment, 
including three virtual guests(VMs) to act as test systems. 
This guide assumes that you already have Ansible installed and working,
also have a spare system capable of KVM virtualization with at least 4GB of RAM running on Fedora 29.

## Package Prerequisites
```
ansible >= 2.5
```
## Setting up Beaker

The playbook sets the entire environment in several steps:

  1. Defines virtual machines and a virtual network called beaker.
  2. Provisions the server and the lab controller as one virtual machine. 
     SSH Keys between host and virtual machine are exchanged to easy access and control of test systems using virsh. 
     Default root password used is **beaker**.
  3. Provisions the test machines and adds them as available resources to the lab controller/server.

## Start the setup using Ansible:
```
ansible-playbook setup_beaker.yml --ask-become-pass
```
