# Creates a kernel configuartion with an ident of $name.
define freebsd::kernel (
  $options = [],
  $device  = [],
){

  include freebsd::src
  include freebsd::kernel::strip

  $kernelname = inline_template("<%= name.upcase %>")

  exec { "copy generic kernel to ${name}":
    command => "/bin/cp /root/kernels/GENERIC.stripped /root/kernels/${kernelname}",
    require => Exec["strip generic kernel"],
    creates => "/root/kernels/${kernelname}",
  }

  file_line { "set kernel ident for ${kernelname}":
    path    => "/root/kernels/${kernelname}",
    line    => "ident ${kernelname}",
    require => Exec["copy generic kernel to ${name}"],
  }

  file { "/usr/src/sys/amd64/conf/${kernelname}":
    ensure => link,
    target => "/root/kernels/${kernelname}",
  }

}
