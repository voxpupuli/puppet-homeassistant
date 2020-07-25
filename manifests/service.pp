class homeassistant::service (
  $home         = $homeassistant::home,
) inherits homeassistant {
  service { 'homeassistant':
    ensure  => true,
    enable  => true,
    require => Systemd::Unit_file['homeassistant.service'],
  }
}
