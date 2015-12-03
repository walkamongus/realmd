# == Class realmd::params
#
# This class is meant to be called from realmd.
# It sets variables according to platform.
#
class realmd::params {
  case $::osfamily {
    'RedHat', 'Amazon': {
      $realmd_package_name     = 'realmd'
      $adcli_package_name      = 'adcli'
      $krb_client_package_name = 'krb5-workstation'
      $sssd_package_name       = 'sssd'
      $sssd_service_name       = 'sssd'
      $sssd_config_file        = '/etc/sssd/sssd.conf'
      $sssd_config             = {}
      $sssd_default_config     = {
        'sssd'                  => {
          'config_file_version' => '2',
          'services'            => 'nss,pam',
          'domains'             => 'LDAP',
        },
        'nss'                 => {},
        'pam'                 => {},
        'domain/LDAP'         => {
          'id_provider'       => 'ldap',
          'cache_credentials' => true,
        },
      }
      $mkhomedir_package_names = [
        'oddjob',
        'oddjob-mkhomedir',
      ]
      $enable_mkhomedir        = true
      $enable_mkhomedir_cmd    = '/usr/sbin/authconfig --enablemkhomedir --update'
      $disable_mkhomedir_cmd   = '/usr/sbin/authconfig --disablemkhomedir --update'
      $pam_mkhomedir_check     = '/bin/grep -E \'^USEMKHOMEDIR=yes$\' /etc/sysconfig/authconfig'
      $domain                  = undef
      $domain_join_user        = undef
      $domain_join_password    = undef
      $krb_ticket_join         = false
      $krb_keytab              = undef
      $krb_initialize_config   = false
      $krb_config_file         = '/etc/krb5.conf'
      $krb_config              = {}
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
