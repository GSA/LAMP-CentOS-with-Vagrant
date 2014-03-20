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

  exec { 'Set MySQL to start on boot':
     subscribe   => [
      Package['mysql-server']
    ],
    refreshonly => true,
    path        => '/bin:/usr/bin',
    command     => "chkconfig --level 2345 mysqld on && service mysqld restart && chkconfig --list | grep mysqld", 
  }


  service { "mysqld":
    ensure => running, 
    require => Package["mysql-server"]
  }

}