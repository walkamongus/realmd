require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "realmd::join::password class" do
          let(:params) {{ 
            :domain_join_user     => 'user',
            :domain_join_password => 'password',
            :domain               => 'example.com',
          }}

          it { is_expected.to contain_class('realmd::join::password') }

          it do
            is_expected.to contain_exec('realm_join_with_password').with({
              'path'        => '/usr/bin:/usr/sbin:/bin',
              'command'     => 'echo \'password\' | realm join example.com --unattended --user=user',
              'unless'      => 'realm list --name-only | grep example.com',
              'refreshonly' => 'true',
            })
          end
        end
      end
    end
  end
end
