require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'realmd::install class with default parameters' do
          let(:params) { {} }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('realmd::install') }

          packages = case os_facts[:os]['family']
                     when 'Debian'
                       [
                         'realmd',
                         'sssd',
                         'adcli',
                         'krb5-user',
                         'sssd-tools',
                         'libpam-modules',
                         'libnss-sss',
                         'libpam-sss',
                         'samba-common-bin',
                       ]
                     when 'RedHat'
                       [
                         'realmd',
                         'sssd',
                         'adcli',
                         'krb5-workstation',
                         'oddjob',
                         'oddjob-mkhomedir',
                         'samba-common-tools',
                       ]
                     end

          packages.each do |package|
            it { is_expected.to contain_package(package).with_ensure('installed') }
          end
        end
      end
    end
  end
end
