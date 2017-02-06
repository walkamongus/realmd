# Realmd::Permit will setup permits on realm
define realmd::permit(
  $permitter = $name,
  $ensure = 'present',
  $isgroup = false,
){

  if $isgroup {
    $_exec_command = join(['realm permit -g ', $permitter], ' ')
  } else {
    $_exec_command = join(['realm permit', $permitter], ' ')
  }

  if $ensure == 'present' {
    exec { $_exec_command:
      unless => "realm list | grep permit | grep -q ${permitter}",
    }
  } else {
    exec { "realm permit --withdraw ${permitter}":
      onlyif => "realm list | grep permit | grep -q ${permitter}",
    }
  }
}
