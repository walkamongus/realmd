# == Class realmd::install
#
# This class is called from realmd for install.
#
class realmd::install {

  case $facts['os']['name'] {
    'Ubuntu': {
      include apt

      package { $::realmd::realmd_package_name:
        ensure  => $::realmd::realmd_package_ensure,
        require => Exec['apt_update'],
      }

      package { $::realmd::adcli_package_name:
        ensure  => $::realmd::adcli_package_ensure,
        require => Exec['apt_update'],
      }

      package { $::realmd::krb_client_package_name:
        ensure  => $::realmd::krb_client_package_ensure,
        require => Exec['apt_update'],
      }

      if $realmd::manage_sssd_package {
        package { $::realmd::sssd_package_name:
          ensure  => $::realmd::sssd_package_ensure,
          require => Exec['apt_update'],
        }
      }

      $::realmd::required_packages.each | String $package, Hash $content | {
        package { $package:
          ensure  => $content['ensure'],
          require => Exec['apt_update'],
        }
      }

    }
    default: {
      package { $::realmd::realmd_package_name:
        ensure => $::realmd::realmd_package_ensure,
      }

      package { $::realmd::adcli_package_name:
        ensure => $::realmd::adcli_package_ensure,
      }

      package { $::realmd::krb_client_package_name:
        ensure => $::realmd::krb_client_package_ensure,
      }

      package { $::realmd::sssd_package_name:
        ensure => $::realmd::sssd_package_ensure,
      }

      ensure_packages($::realmd::required_packages)
    }
  }



}
