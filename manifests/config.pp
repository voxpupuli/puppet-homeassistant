class homeassistant::config (
  $location_name = $homeassistant::location_name,
  $latitute      = $homeassistant::latitude,
  $longitude     = $homeassistant::longitude,
  $unit_system   = $homeassistant::unit_system,
  $time_zone     = $homeassistant::time_zone,
  $confdir       = $homeassistant::confdir,
  $known_devices = $homeassistant::known_devices,
  $known_devices_replace = $homeassistant::known_devices_replace,
) inherits homeassistant {
  concat { 'configuration.yaml':
    path   => "${confdir}/configuration.yaml",
    owner  => 'homeassistant',
    group  => 'homeassistant',
    notify => Service['homeassistant'],
  }
  concat::fragment { 'homeassistant':
    target  => 'configuration.yaml',
    order   => '00',
    content => template('homeassistant/homeassistant.yaml.erb'),
  }

  concat { 'known_devices.yaml':
    path    => "${confdir}/known_devices.yaml",
    owner   => homeassistant,
    group   => homeassistant,
    replace => $known_devices_replace,
    mode    => '0640',
    notify  => Service['homeassistant'],
  }

  if $known_devices {
    create_resources('homeassistant::known_device',$known_devices)
  }
}
