require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "realmd::join::keytab class with default krb_config" do
          let(:params) {{ 
            :krb_ticket_join       => true,
            :domain_join_user      => 'user',
            :krb_keytab            => '/tmp/join.keytab',
            :krb_config_file       => '/etc/krb5.conf',
            :domain                => 'example.com',
            :krb_initialize_config => true,
          }}

          it { is_expected.to contain_class('realmd::join::keytab') }

          it do
            is_expected.to contain_file('krb_keytab').with({
              'path'  => '/tmp/join.keytab',
              'owner' => 'root',
              'group' => 'root',
              'mode'  => '0400',
            }).that_comes_before('Exec[run_kinit_with_keytab]')
          end

          it do
            is_expected.to contain_exec('remove_default_krb_config_file').with({
              'path'    => '/usr/bin:/usr/sbin:/bin',
              'command' => 'rm -f /etc/krb5.conf',
              'onlyif'  => 'grep EXAMPLE.COM /etc/krb5.conf',
            }).that_comes_before('File[krb_configuration]')
          end

          it do
            is_expected.to contain_file('krb_configuration').with({
              'path'  => '/etc/krb5.conf',
              'owner' => 'root',
              'group' => 'root',
              'mode'  => '0644',
            }).that_comes_before('Exec[run_kinit_with_keytab]')
          end

          it { should contain_file('krb_configuration').with_content(
            /\[libdefaults\]\ndefault_realm = EXAMPLE.COM\n/
          )}

          it { should contain_file('krb_configuration').with_content(
            /dns_lookup_realm = true\n/
          )}

          it { should contain_file('krb_configuration').with_content(
            /dns_lookup_kdc = true\n/
          )}

          it { should contain_file('krb_configuration').with_content(
            /kdc_timesync = 0\n/
          )}

          it do
            is_expected.to contain_exec('run_kinit_with_keytab').with({
              'path'        => '/usr/bin:/usr/sbin:/bin',
              'command'     => 'kinit -kt /tmp/join.keytab user',
              'refreshonly' => 'true',
            }).that_comes_before('Exec[run_realm_join_with_keytab]')
          end

          it do
            is_expected.to contain_exec('run_realm_join_with_keytab').with({
              'path'        => '/usr/bin:/usr/sbin:/bin',
              'command'     => 'realm join example.com',
              'unless'      => 'realm list --name-only | grep example.com',
              'refreshonly' => 'true',
            })
          end
        end

        context "realmd::join::keytab class with custom krb_config" do
          let(:params) {{ 
            :krb_ticket_join       => true,
            :domain_join_user      => 'user',
            :krb_keytab            => '/tmp/join.keytab',
            :krb_config_file       => '/etc/krb5.conf',
            :domain                => 'example.com',
            :krb_initialize_config => true,
            :krb_config            => {
              'libdefaults'  => {
                'default_realm' => 'EXAMPLE.COM',
              },
              'domain_realm' => {
                'localhost.example.com' => 'EXAMPLE.COM',
              },
              'realms'       => {
                'EXAMPLE.COM' => {
                  'kdc' => 'dc.example.com:88',
                },
              },
            }
          }}

          it { is_expected.to contain_class('realmd::join::keytab') }


          it { should contain_file('krb_configuration').with_content(
            /\[domain_realm\]\nlocalhost.example.com = EXAMPLE.COM\n/
          )}

          it { should contain_file('krb_configuration').with_content(
            /\[libdefaults\]\ndefault_realm = EXAMPLE.COM\n/
          )}

          it { should contain_file('krb_configuration').with_content(
            /\[realms\]\nEXAMPLE.COM = {\n  kdc = dc.example.com:88\n/
          )}

        end
      end
    end
  end
end
