# == Class realmd::install
#
# This class is called from realmd for install.
#
class realmd::install {
  $_package_list = [
    $::realmd::realmd_package_name,
    $::realmd::adcli_package_name,
    $::realmd::krb_client_package_name,
    $::realmd::sssd_package_name,
    $::realmd::samba_package_name,
    $::realmd::mkhomedir_package_names,
  ]
  $_packages = flatten($_package_list)

  package { $_packages:
    ensure => present,
  }
}
