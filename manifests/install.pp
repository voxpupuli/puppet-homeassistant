class homeassistant::install (
  $user         = $homeassistant::user,
  $home         = $homeassistant::home,
  $config       = $homeassistant::config,
  $dependencies = $homeassistant::dependencies,
) inherits homeassistant {

  if $dependencies {
    package{$dependencies:
      ensure => present,
    }
  }

  user{$user:
    ensure => present,
    home   => $home,
    system => true,
  }

  file{$config:
    ensure => directory,
    owner  => $user,
  }

  class{'::python':
    ensure     => present,
    version    => 'python3',
    pip        => 'present',
    virtualenv => 'present',
  }

  python::pyvenv{$home:
    ensure => present,
    owner  => $user,
  }

  python::pip{'homeassistant':
    ensure     => present,
    virtualenv => $home,
  }
  ::systemd::unit_file { 'homeassistant.service':
    content => template("${module_name}/homeassistant.service.erb"),
  }

}
