# Puppet manifest for my PHP dev machine
 


class iptables {

  package { "iptables": 
    ensure => present;
  }

  service { "iptables":
    require => Package["iptables"],

    hasstatus => true,
    status => "true",

    # hasrestart => false,

  }

  file { "/etc/sysconfig/iptables":
    owner   => "root",
    group   => "root",
    mode    => 600,
    replace => true,
    ensure  => present,
    # source  => "puppet:///files/iptables.txt",
    source  => "/vagrant/files/iptables.txt",
    # content => template("puppet:///templates/iptables.txt"),
    require => Package["iptables"],

    notify  => Service["iptables"],
    ;
  }

}



# Install git

class git {

  package{'git':
    ensure=>present,
  }

}



class misc {

  exec { "grap-epel":
    command => "/bin/rpm -Uvh http://fedora-epel.mirror.lstn.net/6/x86_64/epel-release-6-8.noarch.rpm",
    creates => "/etc/yum.repos.d/epel.repo",
    alias   => "grab-epel",
  }

  package { "emacs":
    ensure => present
  }

  package { "ImageMagick":
    ensure => present
  }

}



#Install MySQL

class mysql {

  $password = 'vagrant'

  package { [
      'mysql',
      'mysql-server',
    ]:
    ensure => installed,
  }

  exec { 'Set MySQL server\'s root password':
    subscribe   => [
      Package['mysql-server'],
      Package['mysql'],
    ],
    refreshonly => true,
    unless      => "mysqladmin -uroot -p${password} status",
    path        => '/bin:/usr/bin',
    command     => "mysqladmin -uroot password ${password}",
  }

  service { "mysqld":
    ensure => running, 
    require => Package["mysql-server"]
  }


}



# Install PHP

class php {

  package { [
    'php',
    'php-cli',
    'php-common',
    'php-devel',
    'php-gd',
#    'php-mcrypt',
    'php-intl',
    'php-ldap',
    'php-mbstring',
    'php-mysql',
#    'php-pdo',
    'php-pear',
    'php-pecl-apc',
 #   'php-soap',
    'php-xml',
    'uuid-php',
  ]:
  ensure => present,
  }

  package { "php-pecl-imagick":
    ensure  => present,
    require => Exec["grab-epel"]
  }

  
  # upgrade pear
  exec {"pear upgrade":
    command => "/usr/bin/pear upgrade",
    require => Package['php-pear'],
  }
  
  # set channels to auto discover
  exec { "pear auto_discover" :
    command => "/usr/bin/pear config-set auto_discover 1",
    require => [Package['php-pear']]
  }
  
  # update channels
  exec { "pear update-channels" :
    command => "/usr/bin/pear update-channels",
    require => [Package['php-pear']]
  }
}



class { 'httpd::install': }

include iptables
include git
include misc
include mysql
include php

class { 'wp::cli': }
class { 'wordpress::install': }