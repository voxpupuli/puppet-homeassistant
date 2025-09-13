class homeassistant::install (
  $home    = $homeassistant::home,
  $confdir = $homeassistant::confdir,
) inherits homeassistant {
  group { $homeassistant::group:
    ensure => present,
    system => true,
  }
  user { $homeassistant::user:
    ensure => present,
    home   => $home,
    system => true,
    gid    => $homeassistant::group,
    shell  => '/usr/bin/nologin',
  }
  file { $confdir:
    ensure => directory,
    owner  => $homeassistant::user,
    group  => $homeassistant::group,
  }

  if $homeassistant::install_method == 'package' {
    package { 'home-assistant':
      ensure => 'installed',
      before => File[$confdir], # we need to install the package first because it provides the user/group
    }
    systemd::dropin_file { 'dynamicuser.conf':
      unit    => 'home-assistant.service',
      content => "# THIS FILE IS MANAGED BY PUPPET\n[Service]\nDynamicUser=false\n",
    }
  } else {
    file { "${confdir}/components":
      ensure  => directory,
      owner   => $homeassistant::user,
      group   => $homeassistant::group,
      purge   => true,
      recurse => true,
    }

    class { 'python':
      ensure  => present,
      version => 'system',
      pip     => 'present',
      dev     => 'present',
    }

    python::pyvenv { $home:
      ensure => present,
      owner  => $homeassistant::user,
      group  => $homeassistant::group,
    }

    python::pip { 'homeassistant':
      ensure     => present,
      virtualenv => $home,
      owner      => $homeassistant::user,
      group      => $homeassistant::group,
    }
    systemd::unit_file { 'homeassistant.service':
      content => template("${module_name}/homeassistant.service.erb"),
    }
  }
}
