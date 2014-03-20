# WordPress LAMP Setup based on CentOS 6.3 with Vagrant / Puppet

## Overview

I put together this configuration to get up a full LAMP environment based on CentOS.
So you get a CentOS-VM with 

* Apache
* MySQL
* PHP
* WP-CLI
* Wordpress

**Attention:** This is just a quick vagrant based VM for some of my local development and testing.
Don't use this VM in a production environment.


## Installation

Before you start: 
I am using a 64 bit version of CentOS as base box. So make sure that you can virtualize a 64 bit system.

Clone this repo or just download the source code as Zip file.

Start the VM:

```bash

vagrant up

```

## Usage

The Vagrantfile specifies the IP address that the VM will use (default is `192.168.33.10`) and the hostname is `centos63.local`. 

You should update your hosts file on your machine with these, eg edit `/etc/hosts` and add `192.168.33.10 centos63.local`

Once fully built and deployed, you can reach the WordPress deployment at `http://centos63.local`.

The default Mysql password for root is `vagrant`.

To login into the VM type
```bash
vagrant ssh
```

To halt the VM:
```bash
vagrant halt
```

To reload the VM:
```bash
vagrant reload
```

To run provisioning scripts again on the VM:
```bash
vagrant provision
```

To completely destory the VM:
```bash
vagrant destroy
```