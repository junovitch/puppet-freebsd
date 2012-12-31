class freebsd::src {

  # The following should probably be broken up into a define(s), but we are
  # only working with amd64 and 9.0 boxes for now, so I am not too worried.

  package { "subversion-1.7.6": }

  exec { "checkout source":
    command => '/usr/local/bin/svn co svn://svn.freebsd.org/base/release/9.0.0/ /usr/src/',
    require => Package["subversion-1.7.6"],
    creates => '/usr/src/.svn',
    timeout => '1800',
  }

  # Below here lies a bunch of junk that will copy the GENERIC configuration,
  # strip out the ident, and then add some options using the file_line

  file { "/root/kernels":
    ensure => directory,
  }

  freebsd::kernel {
    "firewall":
  }

  exec { "strip generic kernel":
    command => '/bin/cat /usr/src/sys/amd64/conf/GENERIC | grep -v ident > /root/kernels/GENERIC.stripped',
    require => File['/root/kernels'],
    creates => '/root/kernels/GENERIC.stripped',
  }

  file_line { 'set option ipsec':
    path    => '/root/kernels/FIREWALL',
    line    => 'options IPSEC',
    require => Exec["copy generic kernel to firewall"],
  }

  file_line { 'set device crypto':
    path    => '/root/kernels/FIREWALL',
    line    => 'device crypto  # needed to compile IPSEC support.',
    require => Exec["copy generic kernel to firewall"],
  }

  file_line { 'set device pf':
    path    => '/root/kernels/FIREWALL',
    line    => 'device pf',
    require => Exec["copy generic kernel to firewall"],
  }

  file_line { 'set device pflog':
    path    => '/root/kernels/FIREWALL',
    line    => 'device pflog',
    require => Exec["copy generic kernel to firewall"],
  }

  file_line { 'set device pfsync':
    path    => '/root/kernels/FIREWALL',
    line    => 'device pfsync',
    require => Exec["copy generic kernel to firewall"],
  }

}
