define freebsd::vlan (
  $address   = '',  # CIDR Notation
  $v6address = '',  # Address only
  $prefixlen = '',  # Prefix length for v6 address
  $vlan,
  $dev,
  $ensure = 'present'
){

  $ifname = "vlan${vlan}"

  # We should take the correct action
  if ($ensure == 'present') {

    # FIXME: when createing the vlan interface, the vlan paramaters can only be
    # specified once, so here we are determining of we need to create a v6 and
    # a v4 address, but then we can only set the vlandev on one of the
    # interfaces.  So this does not allow us to use v6 only at the moment, but
    # rather, if you want v6, then you also need to specify a v4 address.
    # There is likely simple fix for this.

    # Add the configuration to rc.conf
    if $address != '' {
      shell_config { "subnet_vlan_${name}_${ifname}":
        file  => '/etc/rc.conf',
        key   => "ifconfig_${ifname}",
        value => "inet ${address} vlan ${vlan} vlandev ${dev}",
      }
    }

    if $v6address != '' {
      shell_config { "subnet_vlan_${name}_${ifname}_ipv6":
        file  => '/etc/rc.conf',
        key   => "ifconfig_${ifname}_ipv6",
        value => "inet6 ${v6address}",
      }
    }

    # Create the vlan interface
    exec { "create_interface_${name}_${ifname}":
      unless  => "/sbin/ifconfig ${ifname}",
      command => "/sbin/ifconfig ${ifname} create",
      notify  => Exec["start_vlan_${name}_${ifname}"],
      require => Shell_config["subnet_vlan_${name}_${ifname}"],
    }

    # Start the vlan interface
    exec { "start_vlan_${name}_${ifname}":
      refreshonly => true,
      command     => "/usr/sbin/service netif start ${ifname}",
      require     => Exec["create_interface_${name}_${ifname}"],
    }

  }

}
