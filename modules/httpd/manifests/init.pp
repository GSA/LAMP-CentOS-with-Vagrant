
class httpd::install {

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

   file { '/etc/httpd/conf.d/wordpress.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/vagrant/files/etc/httpd/vhosts/wordpress.conf',
    require => Package['httpd'],
    notify  => Service['httpd']
  }

  file { '/etc/httpd/modules/rewrite.load':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => '/vagrant/files/etc/httpd/modules/rewrite.load',
    require => Package['httpd'],
    notify  => Service['httpd']
  }


}

