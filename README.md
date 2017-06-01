# Puppet module for Home Assistant 

[![Build Status](https://travis-ci.org/voxpupuli/puppet-homeassistant.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-homeassistant)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-homeassistant/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-homeassistant)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/homeassistant.svg)](https://forge.puppetlabs.com/puppet/homeassistant)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/homeassistant.svg)](https://forge.puppetlabs.com/puppet/homeassistant)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/homeassistant.svg)](https://forge.puppetlabs.com/puppet/homeassistant)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/homeassistant.svg)](https://forge.puppetlabs.com/puppet/homeassistant)

## Description
Home Assistant is an open-source home automation platform running on Python 3. This
puppet module can be used to install and configurue Home Assistant.
Home assistant is installed within an python3 virtualenv environment.

Home Assistant - https://home-assistant.io/

## Usage
To install and start homeassistant

```puppet
include ::homeassistant
```

or with a custom configuration.

```puppet
class{'::homeassistant':
    location_name => '245b Rue d\'Allemogne',
    latitude      => 46.237,
    longitude     => 5.981,
    elevation     => 505,
    unit_system   => 'metric',
    time_zone     => 'Europe/Paris'
  }

```

### Parameters for homeassistant class
* `user` - Specify a username to run the service as. Default: `homeassistant`
* `home` - Home directory of user and virtualeven for software. Default: `/srv/homeassistant`
* ...

## Adding Components
Simple components with no configuration.

```puppet
homeassistant::component{[
    'config',
    'http',
    'frontend',
    'updater',
    'discovery',
    'conversation',
    'history',
    'sun',
    'logbook',
  ]:}
```

Components with configuration.

```puppet
homeassistant::component{'tts':
  config => {'platform' => 'google'}
} 

homeassistant::component{'device_tracker':
  config => [
    {'platform' => 'netgear',
     'host'     => 'router.example.org',
     'username' => 'admin',
     'password' => 'secret',
    }
  ],
}
```


## Authors
puppet-homeassistant is maintained by VoxPupuli. It was
originally written by Steve Traylen.

