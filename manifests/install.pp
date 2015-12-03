# == Class realmd::install
#
# This class is called from realmd for install.
#
class realmd::install {

  package { $::realmd::package_name:
    ensure => present,
  }
}
