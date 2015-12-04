# == Class realmd::config
#
# This class is called from realmd for service config.
#
class realmd::config {

  $_realmd_config      = $::realmd::realmd_config
  $_realmd_config_file = $::realmd::realmd_config_file

  file { $_realmd_config_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('realmd/realmd.conf.erb'),
  }

}
