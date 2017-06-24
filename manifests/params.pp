# == Class realmd::params
#
# This class is meant to be called from realmd.
# It sets variables according to platform.
#
class realmd::params {

  $realmd_package_name    = 'realmd'
  $realmd_config_file     = '/etc/realmd.conf'
  $realmd_config          = {}
  $adcli_package_name     = 'adcli'
  $sssd_package_name      = 'sssd'
  $sssd_service_name      = 'sssd'
  $sssd_config_file       = '/etc/sssd/sssd.conf'
  $sssd_config            = {}
  $sssd_config_cache_file = '/var/lib/sss/db/config.ldb'
  $manage_sssd_config     = false
  $domain                 = $::domain
  $domain_join_user       = undef
  $domain_join_password   = undef
  $krb_ticket_join        = false
  $krb_keytab             = undef
  $krb_config_file        = '/etc/krb5.conf'
  $manage_krb_config      = true
  $krb_config             = {
    'logging' => {
      'default' => 'FILE:/var/log/krb5libs.log',
    },
    'libdefaults' => {
      'default_realm'    => upcase($::domain),
      'dns_lookup_realm' => true,
      'dns_lookup_kdc'   => true,
      'kdc_timesync'     => '0',
    },
  }

  case $::osfamily {
    'RedHat', 'Amazon': {
      $krb_client_package_name = 'krb5-workstation'
      $required_packages       = {
        'sssd'               => { 'ensure' => 'present', },
        'oddjob'             => { 'ensure' => 'present', },
        'oddjob-mkhomedir'   => { 'ensure' => 'present', },
        'adcli'              => { 'ensure' => 'present', },
        'samba-common-tools' => { 'ensure' => 'present', },
      }
    }
    'Debian': {
      $krb_client_package_name = 'krb5-user'
      $required_packages       = {
        'sssd-tools'       => { 'ensure' => 'present', },
        'sssd'             => { 'ensure' => 'present', },
        'libpam-modules'   => { 'ensure' => 'present', },
        'libnss-sss'       => { 'ensure' => 'present', },
        'libpam-sss'       => { 'ensure' => 'present', },
        'adcli'            => { 'ensure' => 'present', },
        'samba-common-bin' => { 'ensure' => 'present', },
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
