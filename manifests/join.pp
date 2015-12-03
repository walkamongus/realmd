# == Class realmd::join
#
# This class is called from realmd for joining AD.
#
class realmd::join {

  if $::realmd::krb_ticket_join {
    class { '::realmd::join::keytab': }
  }
  else {
    class { '::realmd::join::password': }
  }

}
