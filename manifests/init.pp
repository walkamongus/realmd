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
  $realmd_package_name             = $::realmd::params::realmd_package_name,
  $realmd_config_file              = $::realmd::params::realmd_config_file,
  $realmd_config                   = $::realmd::params::realmd_config,
  $adcli_package_name              = $::realmd::params::adcli_package_name,
  $krb_client_package_name         = $::realmd::params::krb_client_package_name,
  $sssd_package_name               = $::realmd::params::sssd_package_name,
  $sssd_service_name               = $::realmd::params::sssd_service_name,
  $sssd_config_file                = $::realmd::params::sssd_config_file,
  $sssd_config_cache_file          = $::realmd::params::sssd_config_cache_file,
  $sssd_config                     = $::realmd::params::sssd_config,
  $manage_sssd_config              = $::realmd::params::manage_sssd_config,
  $mkhomedir_package_names         = $::realmd::params::mkhomedir_package_names,
  $extra_packages                  = $::realmd::params::extra_packages,
  $domain                          = $::realmd::params::domain,
  $domain_join_user                = $::realmd::params::domain_join_user,
  $domain_join_password            = $::realmd::params::domain_join_password,
  $krb_ticket_join                 = $::realmd::params::krb_ticket_join,
  $krb_keytab                      = $::realmd::params::krb_keytab,
  $krb_config_file                 = $::realmd::params::krb_config_file,
  $krb_config                      = $::realmd::params::krb_config,
  $manage_krb_config               = $::realmd::params::manage_krb_config,
) inherits ::realmd::params {

  if $krb_ticket_join == false {
    if ($domain_join_user and !$domain_join_password) {
      fail('Cannot set domain_join_user without domain_join_password')
    }
  }
  if ($domain_join_password and !$domain_join_user) {
    fail('Cannot set domain_join_password without domain_join_user')
  }

  if $manage_sssd_config and empty($sssd_config) {
    fail('The sssd_config parameter cannot be an empty hash when managing the SSSD configuration')
  }

  if $manage_krb_config and empty($krb_config) {
    fail('The krb_config parameter cannot be an empty hash when managing the Kerberos client configuration')
  }

  validate_string(
    $realmd_package_name,
    $adcli_package_name,
    $krb_client_package_name,
    $sssd_package_name,
    $sssd_service_name,
    $domain,
    $domain_join_user,
    $domain_join_password,
  )

  validate_absolute_path(
    $realmd_config_file,
    $sssd_config_file,
    $krb_config_file,
  )

  validate_hash(
    $realmd_config,
    $sssd_config,
    $krb_config,
  )

  validate_array(
    $mkhomedir_package_names,
  )

  validate_bool(
    $manage_sssd_config,
    $krb_ticket_join,
    $manage_krb_config,
  )

  if $krb_keytab { validate_absolute_path($krb_keytab) }

  class { '::realmd::install': }
  -> class { '::realmd::config': }
  ~> class { '::realmd::join': }
  -> class { '::realmd::sssd::config': }
  ~> class { '::realmd::sssd::service': }

}
