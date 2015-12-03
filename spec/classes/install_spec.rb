require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "realmd::install class with default parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('realmd::install') }
          
          packages = [
            'realmd',
            'sssd',
            'oddjob',
            'oddjob-mkhomedir',
            'adcli',
            'krb5-workstation'
          ]

          packages.each do |package|
            it do 
              is_expected.to contain_package(package).with({
                'ensure' => 'present',
              })
            end
          end
        end
      end
    end
  end
end
