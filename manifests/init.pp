class homeassistant (
  $user   = 'homeassistant',
  $home   = '/srv/homeassistant',
  $config = '/etc/homeassistant',
  $dependencies = $homeassistant::params::dependencies,
) inherits homeassistant::params {

  class{'::homeassistant::install':} ~>
  class{'::homeassistant::service':}

  contain ::homeassistant::install
  contain ::homeassistant::service

}
