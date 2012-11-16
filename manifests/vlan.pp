define freebsd::vlan (
  $address,  # CIDR Notation
  $vlan,
  $dev,
  $ensure = 'present'
){

  $ifname = "vlan${vlan}"

  # We should take the correct action
  if ($ensure == 'present') {

    # Add the configuration to rc.conf
    shell_config { "subnet_vlan_${name}_${ifname}":
      file  => '/etc/rc.conf',
      key   => "ifconfig_${ifname}",
      value => "inet ${address} vlan ${vlan} vlandev ${dev}",
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
