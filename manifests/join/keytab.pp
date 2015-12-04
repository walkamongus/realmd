# == Class realmd::join::keytab
#
# This class is called from realmd for performing
# a passwordless AD join with a Kerberos keytab
#
class realmd::join::keytab {

  $_domain            = $::realmd::domain
  $_domain_join_user  = $::realmd::domain_join_user
  $_krb_keytab        = $::realmd::krb_keytab
  $_krb_config_file   = $::realmd::krb_config_file
  $_krb_config        = $::realmd::krb_config
  $_manage_krb_config = $::realmd::manage_krb_config

  file { 'krb_keytab':
    path   => $_krb_keytab,
    owner  => 'root',
    group  => 'root',
    mode   => '0400',
    before => Exec['run_kinit_with_keytab'],
  }

  if $_manage_krb_config {
    file { 'krb_configuration':
      ensure  => present,
      path    => $_krb_config_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('realmd/krb5.conf.erb'),
      before  => Exec['run_kinit_with_keytab'],
    }
  }

  exec { 'run_kinit_with_keytab':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "kinit -kt ${_krb_keytab} ${_domain_join_user}",
    refreshonly => true,
    before      => Exec['run_realm_join_with_keytab'],
  }

  exec { 'run_realm_join_with_keytab':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "realm join ${_domain}",
    unless      => "realm list --name-only | grep ${_domain}",
    refreshonly => true,
    require     => Exec['run_kinit_with_keytab'],
  }

}
