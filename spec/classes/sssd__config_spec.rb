require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "realmd::sssd::config class with default config" do
          let(:params) {{
            :manage_sssd_config => true,
          }}

          it { should contain_file('/etc/sssd/sssd.conf').with({
	          :owner => 'root',
	          :group => 'root',
	          :mode  => '0600'
          }).that_notifies('Service[sssd]') }

	        it { should contain_file('/etc/sssd/sssd.conf').with_content(/services = nss,pam/) }
        end
      end
    end
  end
end
