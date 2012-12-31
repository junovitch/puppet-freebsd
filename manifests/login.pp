class freebsd::login (
  $default = {
    'passwd_format'   => 'md5',
    'copyrighta'       => '/etc/COPYRIGHT',
    'welcome'         => '/etc/motd',
    'setenv'          => 'MAIL/var/mail/$,BLOCKSIZE=K,FTP_PASSIVE_MODE=YES',
    'path'            => '/sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin ~/bin',
    'nologin'         => '/var/run/nologin',
    'cputime'         => 'unlimited',
    'datasize'        => 'unlimited',
    'stacksize'       => 'unlimited',
    'memorylocked'    => 'unlimited',
    'memoryuse'       => 'unlimited',
    'filesize'        => 'unlimited',
    'coredumpsize'    => 'unlimited',
    'openfiles'       => 'unlimited',
    'maxproc'         => 'unlimited',
    'sbsize'          => 'unlimited',
    'vmemoryuse'      => 'unlimited',
    'swapuse'         => 'unlimited',
    'pseudoterminals' => 'unlimited',
    'priority'        => '0',
    'ignoretime'      => '@',
    'umask'           => '022'
  }
) {

  file { '/etc/login.conf':
    path    => '/etc/login.conf',
    owner   => 'root',
    group   => '0',
    mode    => '0644',
    content => template('freebsd/etc/login.conf.erb'),
    notify  => Exec['update login database'],
  }

  exec{ 'update_login_database':
    command     => '/usr/bin/cap_mkdb /etc/login.conf',
    refreshonly => true,
  }

}
