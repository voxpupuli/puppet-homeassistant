class homeassistant::install (
  $home    = $homeassistant::home,
  $confdir = $homeassistant::confdir,
) inherits homeassistant {
  group { 'homeassistant':
    ensure => present,
    system => true,
  }

  user { 'homeassistant':
    ensure => present,
    home   => $home,
    system => true,
    gid    => 'homeassistant',
  }

  file { $confdir:
    ensure => directory,
    owner  => 'homeassistant',
    group  => 'homeassistant',
  }
  file { "${confdir}/components":
    ensure  => directory,
    owner   => 'homeassistant',
    group   => 'homeassistant',
    purge   => true,
    recurse => true,
  }

  class { 'python':
    ensure  => present,
    version => 'python3',
    pip     => 'present',
    dev     => 'present',
  }

  python::pyvenv { $home:
    ensure => present,
    owner  => 'homeassistant',
    group  => 'homeassistant',
  }

  python::pip { 'homeassistant':
    ensure     => present,
    virtualenv => $home,
    owner      => 'homeassistant',
    group      => 'homeassistant',
  }
  systemd::unit_file { 'homeassistant.service':
    content => template("${module_name}/homeassistant.service.erb"),
  }
}
