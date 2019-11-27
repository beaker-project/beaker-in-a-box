# Beaker in a box
Beaker in a box provides a way of using Ansible to install and configure a complete working Beaker environment, 
including three virtual guests(VMs) to act as test systems. 
This guide assumes that you already have Ansible installed and working,
also have a spare system capable of KVM virtualization with at least 4GB of RAM running on Fedora 30.

## Package Prerequisites
```
ansible >= 2.5
python3
```
## Setting up Beaker

The playbook sets the entire environment in several steps:

  1. Defines virtual machines and a virtual network called beaker.
  2. Provisions the server and the lab controller as one virtual machine. 
     SSH Keys between host and virtual machine are exchanged to easy access and control of test systems using virsh. 
     Default root password used is **beaker**.
  3. Provisions the test machines and adds them as available resources to the lab controller/server.

## Start the setup using Ansible
```bash
ansible-playbook setup_beaker.yml --ask-become-pass
```

## Customizing the provisioning

By default the Server and Lab Controller VM is provisioned from a CentOS 7 HTTP URL. If you prefer to provision it from a different HTTP URL, run the playbook by passing [variables on the command line](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#passing-variables-on-the-command-line) which will overwrite the default.

For example, create a new YAML file `extravars.yml`:
```yml
---
netinstall_url: http://mirror.centos.org/centos/7/os/x86_64/
kickstart_repos:
  updates: http://mirror.centos.org/centos/7/updates/x86_64/
```

It provides the netinstall URL and additional repositories the VM is provisioned with. Then run the playbook and include the file to the ansible-playbook command:
```bash
ansible-playbook setup_beaker.yml --ask-become-pass -e@extravars.yml
```
In the same fashion, you can add additional distros during the provisioning process by setting the user_distros variable. To illustrate this, here is an example:
```yml
---
user_distros:
  - http://mirror.centos.org/centos/6.8/os/x86_64/
```
This will add CentOS 6.8 as an additional distribution, among the ones already added by default, to provision test machines from.

## Verifying the server installation

All the virtual machines should be configured at this point.

Visiting http://beaker-server-lc.beaker/bkr/ from your host systems’s browser should show the beaker systems page. The Ansible playbook created an administrator user for us. Both the username and password are admin.

Now that you’ve logged into the web interface, it’s time to schedule a job. An easy way to schedule a job is by performing a system scan for one of your test systems. On the systems page, click on a system and navigate to the **Details** tab. Schedule a scan by clicking on the **Scan** button.

The robust web interface exposes many of Beakers features and is easy to work with. Beaker also provides several CLI tools to manage your Beaker setup. Attempt to ssh into the Beaker server to access the tools directly:
```bash
ssh root@beaker-server-lc.beaker -i ~/.ssh/id_rsa
```
_Remember, the default root password on the Beaker server is beaker._

Or you can install and configure the bkr client to use your local Beaker server (see [Installing and configuring the client](https://beaker-project.org/docs-develop/user-guide/bkr-client.html#installing-bkr-client)). After installing and configuring the client on your local workstation, run bkr whoami through the client to check that is working.

## Next Steps

The playbook has already taken care of adding tasks, importing distros and adding systems, but for completeness we recommend reading the next sections to get a better understanding by proceeding to [adding tasks](https://beaker-project.org/docs-develop/user-guide/tasks.html#adding-tasks), [importing distros](https://beaker-project.org/docs-develop/admin-guide/distro-import.html#importing-distros), [adding systems](https://beaker-project.org/docs-develop/user-guide/systems/adding.html#adding-systems), and [running jobs](https://beaker-project.org/docs-develop/user-guide/jobs.html#jobs).
