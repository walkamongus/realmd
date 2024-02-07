require 'spec_helper'

describe 'realmd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'realmd::config class with default parameters' do
          it do
            is_expected.to contain_file('/etc/realmd.conf')
              .with(
                owner: 'root',
                group: 'root',
                mode: '0640',
              )
          end
        end
      end
    end
  end
end
