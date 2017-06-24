# == Class realmd::params
#
# This class is meant to be called from realmd.
# It sets variables according to platform.
#
class realmd::params {
  case $::osfamily {
    'RedHat', 'Amazon': {
      $realmd_package_name     = 'realmd'
      $realmd_config_file      = '/etc/realmd.conf'
      $realmd_config           = {}
      $adcli_package_name      = 'adcli'
      $krb_client_package_name = 'krb5-workstation'
      $sssd_package_name       = 'sssd'
      $sssd_service_name       = 'sssd'
      $sssd_config_file        = '/etc/sssd/sssd.conf'
      $sssd_config_cache_file  = '/var/lib/sss/db/config.ldb'
      $sssd_config             = {}
      $manage_sssd_config      = false
      $mkhomedir_package_names = [
        'oddjob',
        'oddjob-mkhomedir',
        'samba-common-tools',
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

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::operatingsystemrelease, '8.04') < 1 {
      $init_style = 'debian'
    } elsif versioncmp($::operatingsystemrelease, '15.04') < 0 {
      $init_style = 'upstart'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem =~ /Scientific|CentOS|RedHat|OracleLinux/ {
    if versioncmp($::operatingsystemrelease, '7.0') < 0 {
      $init_style = 'service'
    } else {
      $init_style  = 'systemd'
    }
  } elsif $::operatingsystem == 'Fedora' {
    if versioncmp($::operatingsystemrelease, '12') < 0 {
      $init_style = 'service'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Debian' {
    if versioncmp($::operatingsystemrelease, '8.0') < 0 {
      $init_style = 'debian'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Archlinux' {
    $init_style = 'systemd'
  } elsif $::operatingsystem == 'OpenSuSE' {
    $init_style = 'systemd'
  } elsif $::operatingsystem =~ /SLE[SD]/ {
    if versioncmp($::operatingsystemrelease, '12.0') < 0 {
      $init_style = 'sles'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Darwin' {
    $init_style = 'launchd'
  } elsif $::operatingsystem == 'Amazon' {
    $init_style = 'service'
  } else {
    $init_style = undef
  }
  if $init_style == undef {
    fail('Unsupported OS')
  }
}
