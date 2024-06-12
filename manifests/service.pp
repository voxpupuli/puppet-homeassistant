# @api private
class homeassistant::service {
  service { $homeassistant::service_name:
    ensure  => true,
    enable  => true,
  }
}
