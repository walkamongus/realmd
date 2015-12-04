# == Class realmd::join
#
# This class is called from realmd for joining AD.
#
class realmd::join {

  if $::realmd::krb_ticket_join {
    contain '::realmd::join::keytab'
  }
  else {
    contain '::realmd::join::password'
  }

}
