define homeassistant::component (
  $component = $name,
  $config = undef,
  String $confdir = '/etc/homeassistant',
) {

  include homeassistant

  if $component == $name {
    $_instance  = $component
  } else {
    $_instance = "${component} ${name}"
  }


  # If there is a hash of connfiguration put it in it's own file
  # otherwise don't bother creating a file.
  if $config {
    $_content = "# Component ${_instance}\n${_instance}: !include components/${component}/${name}.yaml\n\n"
    ensure_resource('file', "${confdir}/components/${component}",{
      ensure  => directory,
      owner   => 'homeassistant',
      group   => 'homeassistant',
      notify   => Service['homeassistant'],
    })
    file{"${confdir}/components/${component}/${name}.yaml":
      ensure  => file,
      owner   => 'homeassistant',
      group   => 'homeassistant',
      content => inline_template("# Puppet config for component <%= @_instance %> \n<%= @config.to_yaml(:line_width => -1) %>\n"),
      notify  => Service['homeassistant'],
    }
  } else {
    $_content = "# Component ${_instance}\n${_instance}:\n\n"
  }

  concat::fragment{$name:
    target  => 'configuration.yaml',
    order   => '05',
    content => $_content,
  }
}
