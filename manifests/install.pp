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
    $::realmd::mkhomedir_package_names,
    $::realmd::krb_pam_package_name,
  ]
  $_packages = flatten($_package_list)

  package { $_packages:
    ensure => latest,
  }
}
