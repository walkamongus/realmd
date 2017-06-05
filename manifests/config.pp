# == Class realmd::config
#
# This class is called from realmd for service config.
#
class realmd::config {

  $_realmd_config      = $::realmd::realmd_config
  $_realmd_config_file = $::realmd::realmd_config_file

  file { $_realmd_config_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('realmd/realmd.conf.erb'),
  }

  if $::osfamily == 'Debian' {
    file { '/usr/share/pam-configs/realmd_mkhomedir':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/realmd/realmd_mkhomedir',
      notify => Exec['realm-pam-auth-update'],
    }

    exec { 'realm-pam-auth-update':
      command     => '/usr/sbin/pam-auth-update --package',
      refreshonly => true,
    }

  }

  contain '::realmd::krb::config'

}
