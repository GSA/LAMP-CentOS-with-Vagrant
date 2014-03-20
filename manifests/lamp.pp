# Puppet manifest for WordPress on CentOS
 


class iptables {

  package { "iptables": 
    ensure => present;
  }

  service { "iptables":
    require => Package["iptables"],
    hasstatus => true,
    status => "true",
  }

  file { "/etc/sysconfig/iptables":
    owner   => "root",
    group   => "root",
    mode    => 600,
    replace => true,
    ensure  => present,
    source  => "/vagrant/files/iptables.txt",
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



include iptables
include misc
include git

class { 'httpd::install': }
class { 'mysql::install': }
class { 'php::install': }
class { 'wp::cli': }
class { 'wordpress::install': }