class freebsd::src (
  $dir     = '/usr/src',
  $release = '9.1.0',
) {

  package { "devel/subversion": }

  exec { "checkout source":
    command => "/usr/local/bin/svn co svn://svn.freebsd.org/base/release/${release}/ ${dir}/",
    creates => "${dir}/.svn",
    timeout => '1800',
    require => Package["devel/subversion"],
  }
}
