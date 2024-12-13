class homeassistant::config (
  $location_name = $homeassistant::location_name,
  $latitute      = $homeassistant::latitude,
  $longitude     = $homeassistant::longitude,
  $unit_system   = $homeassistant::unit_system,
  $time_zone     = $homeassistant::time_zone,
  $confdir       = $homeassistant::confdir,
  $known_devices = $homeassistant::known_devices,
  $known_devices_replace = $homeassistant::known_devices_replace,
  $external_url = $homeassistant::external_url,
  $server_host = $homeassistant::server_host,
) inherits homeassistant {
  concat { 'configuration.yaml':
    path   => "${confdir}/configuration.yaml",
    owner  => $homeassistant::user,
    group  => $homeassistant::group,
  }
  concat::fragment { 'homeassistant':
    target  => 'configuration.yaml',
    order   => '00',
    content => template('homeassistant/homeassistant.yaml.erb'),
  }

  if $known_devices {
    concat { 'known_devices.yaml':
      path    => "${confdir}/known_devices.yaml",
      owner   => $homeassistant::user,
      group   => $homeassistant::group,
      replace => $known_devices_replace,
      mode    => '0640',
    }
    create_resources('homeassistant::known_device',$known_devices)
  }
}
