class homeassistant::params {

  case $::osfamily {
    'Debian':  {
      $dependencies = ['python3-venv']
    }
    default: {
      $dependencies = undef
    }
  }
}
