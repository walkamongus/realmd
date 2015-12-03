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
  $package_name = $::realmd::params::package_name,
  $service_name = $::realmd::params::service_name,
) inherits ::realmd::params {

  # validate parameters here

  class { '::realmd::install': } ->
  class { '::realmd::config': } ~>
  class { '::realmd::service': } ->
  Class['::realmd']
}
