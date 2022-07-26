require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "realmd::join::password class" do
          let(:params) do
            {
              :domain_join_user     => 'user',
              :domain_join_password => 'password',
              :domain               => 'example.com',
            }
          end

          it { is_expected.to contain_class('realmd::join::password') }

          it do
            command = '/usr/libexec/realm_join_with_password realm join example.com --unattended --user=user'
            unless facts.dig(:os,'distro','id') == 'Ubuntu' && %w[xenial bionic focal].include?(facts.dig(:os,'distro','codename'))
               command += ' --computer-name=foo'
            end
            is_expected.to contain_exec('realm_join_with_password').with({
              'path'    => '/usr/bin:/usr/sbin:/bin',
              'command' => command,
              'unless'  => "klist -k /etc/krb5.keytab | grep -i 'foo@example.com'",
            })
          end
        end
      end
    end
  end
end
