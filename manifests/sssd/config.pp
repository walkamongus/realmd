# == Class realmd::sssd::config
#
# This class is called from realmd for SSSD service configuration.
#
class realmd::sssd::config {

  $_final_config = deep_merge($::realmd::sssd_default_config, $::realmd::sssd_config)

  file { $::realmd::sssd_config_file:
    content => template('realmd/sssd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

  if $::realmd::enable_mkhomedir {
    exec { 'enable_mkhomedir':
      command => $::realmd::enable_mkhomedir_cmd,
      unless  => $::realmd::pam_mkhomedir_check,
    }
  }
  else {
    exec { 'disable_mkhomedir':
      command => $::realmd::disable_mkhomedir_cmd,
      onlyif  => $::realmd::pam_mkhomedir_check,
    }
  }

}
