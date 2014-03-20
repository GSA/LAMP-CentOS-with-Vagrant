# Install PHP

class php::install {

  package { [
    'php',
    'php-cli',
    'php-common',
    'php-devel',
    'php-gd',
    'php-intl',
    'php-ldap',
    'php-mbstring',
    'php-mysql',
    'php-pear',
    'php-pecl-apc',
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