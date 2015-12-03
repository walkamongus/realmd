# == Class realmd::params
#
# This class is meant to be called from realmd.
# It sets variables according to platform.
#
class realmd::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'realmd'
      $service_name = 'realmd'
    }
    'RedHat', 'Amazon': {
      $package_name = 'realmd'
      $service_name = 'realmd'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
