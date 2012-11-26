define freebsd::network::lagg (
  $laggproto = 'lacp',
  $laggports = [],
  $mtu = ''
) {

  # Set the MTU of the LAGG interface.
  if ($mtu != '') {
    os::freebsd::network::interface { $laggports: mtu => $mtu; }
  }

  # Build up the lagg interface string here for simplicity
  $lagg_string = inline_template("laggproto ${laggproto} laggport <%= laggports.join(' laggport ') %> up")

  # Add the ifconfig line to rc.conf
  shell_config { "configure_lagg_${name}":
    file  => '/etc/rc.conf',
    key   => "ifconfig_${name}",
    value => "${lagg_string}"
  }

}
