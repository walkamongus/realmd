# == Class realmd::params
#
# This class is meant to be called from realmd.
# It sets variables according to platform.
#
class realmd::params {
  case $::osfamily {
    'RedHat', 'Amazon': {
      $realmd_package_name             = 'realmd'
      $realmd_config_file              = '/etc/realmd.conf'
      $realmd_config                   = {}
      $adcli_package_name              = 'adcli'
      $krb_client_package_name         = 'krb5-workstation'
      $sssd_package_name               = 'sssd'
      $sssd_service_name               = 'sssd'
      $sssd_config_file                = '/etc/sssd/sssd.conf'
      $sssd_config_cache_file          = '/var/lib/sss/db/config.ldb'
      $sssd_config                     = {}
      $manage_sssd_config              = false
      $mkhomedir_package_names         = [
        'oddjob',
        'oddjob-mkhomedir',
      ]
      $extra_packages                  = []
      $domain                          = $::domain
      $domain_join_user                = undef
      $domain_join_password            = undef
      $krb_ticket_join                 = false
      $krb_keytab                      = undef
      $krb_config_file                 = '/etc/krb5.conf'
      $krb_config                      = {
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
      $manage_krb_config               = true
    }
    'Debian': {
      $realmd_package_name     = 'realmd'
      $realmd_config_file      = '/etc/realmd.conf'
      $realmd_config           = {}
      $adcli_package_name      = 'adcli'
      $krb_client_package_name = 'krb5-user'
      $sssd_package_name       = 'sssd'
      $sssd_service_name       = 'sssd'
      $sssd_config_file        = '/etc/sssd/sssd.conf'
      $sssd_config             = {}
      $manage_sssd_config      = false
      $mkhomedir_package_names = [
        'samba-common-bin',
        'libpam-modules',
        'libpam-sss',
        'sssd-tools',
        'libnss-sss',
        'samba',
      ]
      $domain                  = $::domain
      $domain_join_user        = undef
      $domain_join_password    = undef
      $krb_ticket_join         = false
      $krb_keytab              = undef
      $krb_config_file         = '/etc/krb5.conf'
      $krb_config              = {
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
      $manage_krb_config       = true
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
