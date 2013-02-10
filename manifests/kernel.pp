# Creates a kernel configuartion with an ident of $name.
define freebsd::kernel (
  $options = [],
  $device  = [],
){

  include freebsd::src
  include freebsd::kernel::strip

  $kernelname = inline_template("<%= name.upcase %>")
  $src_dir    = $freebsd::kernel::strip::src_dir
  $conf_dir   = $freebsd::kernel::strip::conf_dir

  exec { "copy generic kernel to ${name}":
    command => "/bin/cp ${conf_dir}/GENERIC.stripped ${conf_dir}/${kernelname}",
    require => Exec["strip generic kernel"],
    creates => "${conf_dir}/${kernelname}",
  }

  file_line { "set kernel ident for ${kernelname}":
    path    => "${conf_dir}/${kernelname}",
    line    => "ident ${kernelname}",
    require => Exec["copy generic kernel to ${name}"],
  }

  file { "${src_dir}/sys/amd64/conf/${kernelname}":
    ensure => link,
    target => "${conf_dir}/${kernelname}",
  }

}
