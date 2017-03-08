# == Class realmd::join::keytab
#
# This class is called from realmd for performing
# a passwordless AD join with a Kerberos keytab
#
class realmd::krb::config {
  $_krb_config_file   = $::realmd::krb_config_file
  $_krb_config        = $::realmd::krb_config
  $_manage_krb_config = $::realmd::manage_krb_config

  if $_manage_krb_config {
    file { 'krb_configuration':
      ensure  => file,
      path    => $_krb_config_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('realmd/krb5.conf.erb'),
      notify  => $::realmd::krb_ticket_join ? {
        true => Exec['run_kinit_with_keytab'],
        false => Exec['realm_join_with_password']
      }
    }
  }
}
