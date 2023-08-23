class homeassistant (
  String $location_name,
  Numeric $latitude,
  Numeric $longitude,
  Numeric $elevation,
  Enum['imperial', 'metric'] $unit_system,
  String $time_zone,
  Optional[Hash] $known_devices = undef,
  Stdlib::Absolutepath $home   = '/srv/homeassistant',
  Stdlib::Absolutepath $confdir = $facts['os']['name'] ? {'Archlinux' => '/var/lib/hass', default => '/etc/homeassistant'},
  Boolean $known_devices_replace = false,
  Enum['source', 'package'] $install_method = $facts['os']['name'] ? {'Archlinux' => 'package', default => 'source'},
  String $service_name = $facts['os']['name'] ? {'Archlinux' => 'home-assistant', default => 'homeassistant'},
) {
  class { 'homeassistant::install': }
  -> class { 'homeassistant::config': }
  ~> class { 'homeassistant::service': }

  contain homeassistant::install
  contain homeassistant::config
  contain homeassistant::service
}
