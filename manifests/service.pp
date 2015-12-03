# == Class realmd::service
#
# This class is meant to be called from realmd.
# It ensure the service is running.
#
class realmd::service {

  service { $::realmd::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
