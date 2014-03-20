#Install MySQL

class mysql::install {

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
    enable    => true,
    require => Package["mysql-server"]
  }

}