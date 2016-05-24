# == Class realmd::join::password
#
# This class is called from realmd for
# joining AD using a username and password.
#
class realmd::join::password {

  $_domain    = $::realmd::domain
  $_user      = $::realmd::domain_join_user
  $_password  = $::realmd::domain_join_password

  exec { 'realm_join_with_password':
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "echo '${_password}' | realm join ${_domain} --unattended --user=${_user}",
    unless      => "klist -k /etc/krb5.keytab | grep -i '${::hostname}@${_domain}'",
  }

}
