define homeassistant::known_device (
  String  $mac,
  Boolean $hide_if_away = true,
  String $friendly_name = $title,
  Boolean $track = false,
  Optional[String] $picture = undef,
  Optional[String] $gravatar = undef,
) {
  concat::fragment { "${title}_knowndevice":
    target  => 'known_devices.yaml',
    order   => '05',
    content => template('homeassistant/known_device.yaml.erb'),
  }
}
