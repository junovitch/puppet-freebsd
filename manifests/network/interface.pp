define freebsd::network::interface (
  $address = '',
  $v6address = ''
) {

  Shell_config { file => '/etc/rc.conf' }

  if $address != '' {
    shell_config { "ifconfig ${name}":
      key   => "ifconfig_${name}",
      value => "inet ${address}",
    }
  }

  if $v6address != '' {
    shell_config { "v6ifconfig ${name}":
      key   => "ifconfig_${name}_ipv6",
      value => "inet6 ${v6address}",
    }
  }

}
