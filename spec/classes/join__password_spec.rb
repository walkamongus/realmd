require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) do
          os_facts
        end

        context 'realmd::join::password class' do
          let(:params) do
            {
              domain_join_user: 'user',
              domain_join_password: 'password',
              domain: 'example.com',
            }
          end

          let(:doesnt_use_computer_name) do
            is_ubuntu_20 = (
              facts.dig(:os, 'distro', 'id') == 'Ubuntu' &&
              ['focal', 'jammy'].include?(facts.dig(:os, 'distro', 'codename'))
            )
            is_el8_or_higher = (
              facts.dig(:os, 'family') == 'RedHat' &&
              facts.dig(:os, 'release', 'major').to_i >= 8
            )
            is_ubuntu_20 || is_el8_or_higher
          end

          it { is_expected.to contain_class('realmd::join::password') }

          it do
            command = '/usr/libexec/realm_join_with_password realm join example.com --unattended --user=user'
            if doesnt_use_computer_name
              is_expected.to contain_exec('realm_join_with_password')
                .with(
                  path:    '/usr/bin:/usr/sbin:/bin',
                  command: command,
                  unless:  "klist -k /etc/krb5.keytab | grep -i 'foo@example.com'",
                )
            else
              is_expected.to contain_exec('realm_join_with_password')
                .with(
                  path:    '/usr/bin:/usr/sbin:/bin',
                  command: command + ' --computer-name=foo',
                  unless:  "klist -k /etc/krb5.keytab | grep -i 'foo@example.com'",
                )
            end
          end
        end
      end
    end
  end
end
