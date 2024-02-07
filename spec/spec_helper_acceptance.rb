require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker-puppet'
include BeakerPuppet

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    install_puppet_on(hosts)

    # Install module and dependencies
    hosts.each { |h| h[:distmoduledir] = get_target_module_path(h) }
    mod_name = parse_for_modulename(proj_root).last
    install_dev_puppet_module_on(hosts, source: proj_root, module_name: mod_name)
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { acceptable_exit_codes: [0, 1] }
    end
  end
end
