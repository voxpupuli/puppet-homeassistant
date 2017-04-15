class homeassistant (
  $user         = 'homeassistant',
  $group        = 'homeassistant',
  $home         = '/srv/homeassistant',
  $config       = '/etc/homeassistant',
) {

  class{'::homeassistant::install':}
  ~> class{'::homeassistant::service':}

  contain ::homeassistant::install
  contain ::homeassistant::service

}
