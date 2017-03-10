class homeassistant::install (
  $user         = $homeassistant::user,
  $group        = $homeassistant::group,
  $home         = $homeassistant::home,
  $config       = $homeassistant::config,
) inherits homeassistant {

  group{$group:
    ensure => present,
    system => true,
  }

  user{$user:
    ensure => present,
    home   => $home,
    system => true,
    gid    => $group,
  }

  file{$config:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  class{'::python':
    ensure     => present,
    version    => 'python3',
    pip        => 'present',
    virtualenv => 'present',
    dev        => true,
  }

  python::pyvenv{$home:
    ensure => present,
    owner  => $user,
    group  => $group,
  }

  python::pip{'homeassistant':
    ensure     => present,
    virtualenv => $home,
    owner      => $user,
    group      => $user,
  }
  systemd::unit_file { 'homeassistant.service':
    content => template("${module_name}/homeassistant.service.erb"),
  }

}
