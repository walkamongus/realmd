# == Class realmd::join::password
#
# This class is called from realmd for
# joining AD using a username and password.
#
class realmd::join::password {

  $_domain    = $::realmd::domain
  $_user      = $::realmd::domain_join_user
  $_password  = $::realmd::domain_join_password
  $_join_args = $::realmd::domain_join_args
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
    }
  }

  exec { 'realm_join_with_password':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => "echo '${_password}' | realm join ${_domain} --unattended --user=${_user} ${_join_args}",
    unless  => "klist -k /etc/krb5.keytab | grep -i '${::hostname}'",
  }

}
