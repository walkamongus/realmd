require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      # test with custom password
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "realmd::join::one_time_password class" do
          let(:params) do
            {
              :one_time_password => 'password',
              :domain                        => 'example.com',
            }
          end

          it { is_expected.to contain_class('realmd::join::one_time_password') }

          it do
            is_expected.to contain_exec('realm_join_one_time_password').with({
              'path'    => '/usr/bin:/usr/sbin:/bin',
              'command' => "adcli join --domain=example.com --one-time-password='password'",
              'unless'  => "klist -k /etc/krb5.keytab | grep -i 'foo@example.com'",
            })
          end
        end
      end

      # test with long hostname
      context "on #{os}" do
        let(:facts) do
            facts.merge({
                :hostname => 'to_long_hostname',
            })
        end
        
        context "realmd::join::one_time_password class" do
          let(:params) do
            {
#              :one_time_password => 'to_long_hostnam',
              :domain                        => 'example.com',
            }
          end

          it { is_expected.to contain_class('realmd::join::one_time_password') }

          it do
            is_expected.to contain_exec('realm_join_one_time_password').with({
              'path'    => '/usr/bin:/usr/sbin:/bin',
              'command' => "adcli join --domain=example.com", # 'e' is removed
              'unless'  => "klist -k /etc/krb5.keytab | grep -i 'to_long_hostnam@example.com'",
            })
          end
        end
      end
      
    end
  end
end
