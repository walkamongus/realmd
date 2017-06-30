# == Class realmd::join::password
#
# This class is called from realmd for
# joining AD using a username and password.
#
class realmd::join::password {

  $_domain    = $::realmd::domain
  $_user      = $::realmd::domain_join_user
  $_password  = $::realmd::domain_join_password
  $_ou        = $::realmd::ou

  if $_ou != undef {
    $_realm_args = [$_domain, "--unattended", "--computer-ou=${_ou}", "--user=${_user}"]
  } else {
    $_realm_args = [$_domain, "--unattended", "--user=${_user}"]
  }

  $_args = join($_realm_args, ' ')

  exec { 'realm_join_with_password':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => "echo '${_password}' | realm join ${_args}",
    unless  => "klist -k /etc/krb5.keytab | grep -i '${::hostname[0,15]}@${_domain}'",
  }

}
