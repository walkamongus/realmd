# Class: realmd
# ===========================
#
# Full description of class realmd here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class realmd (
  $realmd_package_name     = $::realmd::params::realmd_package_name,
  $realmd_config_file      = $::realmd::params::realmd_config_file,
  $realmd_config           = $::realmd::params::realmd_config,
  $adcli_package_name      = $::realmd::params::adcli_package_name,
  $krb_client_package_name = $::realmd::params::krb_client_package_name,
  $sssd_package_name       = $::realmd::params::sssd_package_name,
  $sssd_service_name       = $::realmd::params::sssd_service_name,
  $sssd_config_file        = $::realmd::params::sssd_config_file,
  $sssd_config             = $::realmd::params::sssd_config,
  $manage_sssd_config      = $::realmd::params::manage_sssd_config,
  $mkhomedir_package_names = $::realmd::params::mkhomedir_package_names,
  $domain                  = $::realmd::params::domain,
  $domain_join_user        = $::realmd::params::domain_join_user,
  $domain_join_password    = $::realmd::params::domain_join_password,
  $krb_ticket_join         = $::realmd::params::krb_ticket_join,
  $krb_keytab              = $::realmd::params::krb_keytab,
  $krb_config_file         = $::realmd::params::krb_config_file,
  $krb_config              = $::realmd::params::krb_config,
  $manage_krb_config       = $::realmd::params::manage_krb_config,
) inherits ::realmd::params {

  # validate parameters here

  class { '::realmd::install': } ->
  class { '::realmd::config': } ~>
  class { '::realmd::join': } ->
  class { '::realmd::sssd::config': }~>
  class { '::realmd::sssd::service': }

  contain '::realmd::install'
  contain '::realmd::config'
  contain '::realmd::join'
  contain '::realmd::sssd::config'
  contain '::realmd::sssd::service'
}
