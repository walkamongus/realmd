require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      # test with custom password
      context "on #{os}" do
        let(:facts) { os_facts }

        let(:params) do
          {
            domain: 'example.com'
          }
        end

        # test with password
        context 'realmd::join::one_time_password class with password' do
          let(:params) do
            super().merge({ one_time_password: 'password' })
          end

          it { is_expected.to contain_class('realmd::join::one_time_password') }

          it do
            is_expected.to contain_exec('realm_join_one_time_password')
              .with(
                path:    '/usr/bin:/usr/sbin:/bin',
                command: "adcli join --domain=example.com --user-principal=host/foo.example.com@EXAMPLE.COM --login-type=computer --one-time-password='password'",
                unless:  "klist -k /etc/krb5.keytab | grep -i 'foo@example.com'",
              )
          end
        end

        # test without password
        context 'realmd::join::one_time_password class without password' do
          it { is_expected.to contain_class('realmd::join::one_time_password') }

          it do
            is_expected.to contain_exec('realm_join_one_time_password')
              .with(
                path:    '/usr/bin:/usr/sbin:/bin',
                command: 'adcli join --domain=example.com --user-principal=host/foo.example.com@EXAMPLE.COM --login-type=computer --no-password',
                unless:  "klist -k /etc/krb5.keytab | grep -i 'foo@example.com'",
              )
          end
        end

        # test with computer ou
        context 'realmd::join::one_time_password class with computer ou' do
          let(:params) do
            super().merge({ ou: 'ou=computer,dc=example,dc=net' })
          end

          it { is_expected.to contain_class('realmd::join::one_time_password') }

          it do
            is_expected.to contain_exec('realm_join_one_time_password')
              .with(
                path:   '/usr/bin:/usr/sbin:/bin',
                command: "adcli join --domain=example.com --user-principal=host/foo.example.com@EXAMPLE.COM --login-type=computer --computer-ou='ou=computer,dc=example,dc=net' --no-password",
                unless:  "klist -k /etc/krb5.keytab | grep -i 'foo@example.com'",
              )
          end
        end

        # test with long hostname
        context 'realmd::join::one_time_password class with long hostname' do
          let(:node) { 'to-long-hostname.example.com' }

          it { is_expected.to contain_class('realmd::join::one_time_password') }

          it do
            is_expected.to contain_exec('realm_join_one_time_password')
              .with(
                path:    '/usr/bin:/usr/sbin:/bin',
                command: 'adcli join --domain=example.com --user-principal=host/to-long-hostname.example.com@EXAMPLE.COM --login-type=computer --no-password',
                unless:  "klist -k /etc/krb5.keytab | grep -i 'to-long-hostnam@example.com'", # 'e' is removed
              )
          end
        end
      end
    end
  end
end
