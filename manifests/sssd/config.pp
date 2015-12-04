# == Class realmd::sssd::config
#
# This class is called from realmd for SSSD service configuration.
#
class realmd::sssd::config {

  if $realmd::manage_sssd_config {
    $_sssd_config = $::realmd::sssd_config

    file { $::realmd::sssd_config_file:
      content => template('realmd/sssd.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
    }
  }

}
