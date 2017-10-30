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
    $_realm_args = [$_domain, '--unattended', "--computer-ou='OU=${_ou}'", "--user=${_user}"]
  } else {
    $_realm_args = [$_domain, '--unattended', "--user=${_user}"]
  }

  $_args = join($_realm_args, ' ')

  file { '/usr/libexec':
    ensure  => 'directory',
  }

  file { '/usr/libexec/realm_join_with_password':
    ensure  => file,
    owner   => '0',
    group   => '0',
    mode    => '0755',
    content => template('realmd/realm_join_with_password.erb'),
  }

  exec { 'realm_join_with_password':
    environment => ["AD_JOIN_PASSWORD=${_password}"],
    path        => '/usr/bin:/usr/sbin:/bin',
    command     => "/usr/libexec/realm_join_with_password realm join ${_args}",
    unless      => "klist -k /etc/krb5.keytab | grep -i '${::hostname[0,15]}@${_domain}'",
    require     => File['/usr/libexec/realm_join_with_password'],
  }
}
