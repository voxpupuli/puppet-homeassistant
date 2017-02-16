class homeassistant::service (
  $user         = $homeassistant::user,
  $home         = $homeassistant::home,
) inherits homeassistant {

  service{'homeassistant':
    ensure  => true,
    enable  => true,
    require => Systemd::Unit_file['homeassistant.service'],
  }

}
