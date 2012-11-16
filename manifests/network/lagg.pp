define freebsd::network::lagg (
  $laggproto = 'lacp',
  $laggports = [],
  $mtu = ''
) {

  if ($mtu != '') {
    os::freebsd::network::interface { $laggports: mtu => $mtu; }
  }

  $lagg_string = inline_template("laggproto ${laggproto} laggport <%= laggports.join(' laggport ') %> up")

  shell_config { "lagg0_up":
    file  => '/etc/rc.conf',
    key   => "ifconfig_${name}",
    value => "${lagg_string}"
  }

}
