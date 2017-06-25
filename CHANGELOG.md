## Note: Releases 1.x and 2.x
* v1.0.0 release is the last release to be Puppet 3 compatible
* v2.0+ releases support Puppet 4.x and above

## Release 2.0.0
* Convert parameter to use data in module
* Enforce parameter datatypes
* Always run keytab adoption and realm join command if a domain join test fails

## Release 1.0.0
* Remove the mkhomedir packages parameter in favor of a more generic required
packages parameter
* Add Debian support to metadata

## Release 0.1.3
* Add more robust check of domain membership and attempt to join domain if check fails

## Release 0.1.2
* Force rebuilding of SSSD config cache on each configuration change

## Release 0.1.1
* null release

## Release 0.1.0
* initial release
