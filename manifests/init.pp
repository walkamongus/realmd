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
  String $realmd_package_name,
  String $realmd_package_ensure,
  Stdlib::Absolutepath $realmd_config_file,
  Hash $realmd_config,
  String $homedir_umask,
  String $adcli_package_name,
  String $adcli_package_ensure,
  Boolean $manage_krb_client_package,
  String $krb_client_package_name,
  String $krb_client_package_ensure,
  Boolean $manage_sssd_package,
  String $sssd_package_name,
  String $sssd_package_ensure,
  Boolean $manage_sssd_service,
  String $sssd_service_name,
  String $sssd_service_ensure,
  Stdlib::Absolutepath $sssd_config_file,
  Stdlib::Absolutepath $sssd_config_cache_file,
  Hash $sssd_config,
  Boolean $manage_sssd_config,
  String $domain,
  Variant[String, Undef] $domain_join_user,
  Variant[String, Undef] $domain_join_password,
  Boolean $krb_ticket_join,
  Variant[Stdlib::Absolutepath, Undef] $krb_keytab,
  Stdlib::Absolutepath $krb_config_file,
  Hash $krb_config,
  Boolean $manage_krb_config,
  Variant[String, Undef] $ou,
  Hash $required_packages,
  Variant[Array, Undef] $extra_join_options,
  Variant[String[1, 15], Undef] $computer_name,
) {

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

  class { '::realmd::install': }
  -> class { '::realmd::config': }
  ~> class { '::realmd::join': }
  -> class { '::realmd::sssd::config': }
  ~> class { '::realmd::sssd::service': }

}
