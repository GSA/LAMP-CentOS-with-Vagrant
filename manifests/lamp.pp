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


class httpd {

  exec { 'yum-update':
    command => '/usr/bin/yum -y update'
  }

  package { "httpd":
    ensure => present
  }

  package { "httpd-devel":
    ensure  => present
  }

  service { 'httpd':
    name      => 'httpd',
    require   => Package["httpd"],
    ensure    => running,
    enable    => true
  }

  file { "/etc/httpd/conf.d/vhost.conf":
    owner   => "root",
    group   => "root",
    mode    => 644,
    replace => true,
    ensure  => present,
    source  => "/vagrant/files/vhost.conf",
    require => Package["httpd"],
    notify  => Service["httpd"]
  }

}

class phpdev {

  package { "libxml2-devel":
  ensure  => present,
  }


  package { "libXpm-devel":
  ensure  => present,
  }

  package { "gmp-devel":
  ensure  => present,
  }

  package { "libicu-devel":
  ensure  => present,
  }

  package { "t1lib-devel":
  ensure  => present,
  }

  package { "aspell-devel":
  ensure  => present,
  }

  package { "openssl-devel":
  ensure  => present,
  }

  package { "bzip2-devel":
  ensure  => present,
  }

  package { "libcurl-devel":
  ensure  => present,
  }

  package { "libjpeg-devel":
  ensure  => present,
  }

  package { "libvpx-devel":
  ensure  => present,
  }

  package { "libpng-devel":
  ensure  => present,
  }

  package { "freetype-devel":
  ensure  => present,
  }

  package { "readline-devel":
  ensure  => present,
  }

  package { "libtidy-devel":
  ensure  => present,
  }

  package { "libxslt-devel":
  ensure  => present,
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
    'php-mcrypt',
    'php-intl',
    'php-ldap',
    'php-mbstring',
    'php-mysql',
    'php-pdo',
    'php-pear',
    'php-pecl-apc',
    'php-soap',
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



class phpmyadmin {

  package { "phpMyAdmin":
    ensure  => present,
  }

  file { "/etc/httpd/conf.d/phpMyAdmin.conf":
    owner   => "root",
    group   => "root",
    mode    => 644,
    replace => true,
    ensure  => present,
    source  => "/vagrant/files/phpMyAdmin.conf",
    require => Package["httpd"],

    notify  => Service["httpd"],
    ;
  }

  file { "/etc/phpMyAdmin/config.inc.php":
    owner   => "root",
    group   => "root",
    mode    => 644,
    replace => true,
    ensure  => present,
    source  => "/vagrant/files/phpmy_admin_config.inc.php",
    require => Package["phpMyAdmin"]
  }



}

class { 'wordpress::install': }

include iptables
include git
include misc
include httpd
include phpdev
include mysql
include php
include phpmyadmin