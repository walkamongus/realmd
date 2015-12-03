require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "realmd class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('realmd::params') }
          it { is_expected.to contain_class('realmd::install').that_comes_before('realmd::config') }
          it { is_expected.to contain_class('realmd::config') }
          it { is_expected.to contain_class('realmd::service').that_subscribes_to('realmd::config') }

          it { is_expected.to contain_service('realmd') }
          it { is_expected.to contain_package('realmd').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'realmd class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('realmd') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
