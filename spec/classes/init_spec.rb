require 'spec_helper'
describe 'homeassistant' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'with defaults for all parameters' do
        it { should contain_class('homeassistant') }
        it { should contain_user('homeassistant').with_home('/srv/homeassistant') }
        it { should contain_user('homeassistant').with_system(true) }
        it { should contain_user('homeassistant').with_gid('homeassistant') }
        it { should contain_group('homeassistant').with_system(true) }
        it { should contain_file('/etc/homeassistant').with_ensure('directory') }
        it { should contain_file('/etc/homeassistant').with_owner('homeassistant') }
        it { should contain_class('python') }
        it { should contain_python__pyvenv('/srv/homeassistant') }
        it { should contain_systemd__unit_file('homeassistant.service').with_content(%r{^User=homeassistant}) }
        it { should contain_systemd__unit_file('homeassistant.service').with_content(%r{^ExecStart=/srv/homeassistant/bin/hass -c "/etc/homeassistant"}) }
        it { should contain_service('homeassistant').with_enable(true) }
      end
      context 'with all parameters set' do
        let(:params) do {
          :home         => '/foo',
          :config       => '/etc/bar',
          :user         => 'steve',
          :group        => 'friday',
         }  
        end
        it { should contain_group('friday') }
        it { should contain_user('steve').with_gid('friday') }
        it { should contain_user('steve').with_home('/foo') }
        it { should contain_user('steve').with_system(true) }
        it { should contain_file('/etc/bar').with_ensure('directory') }
        it { should contain_file('/etc/bar').with_owner('steve') }
        it { should contain_class('python') }
        it { should contain_python__pyvenv('/foo') }
        it { should contain_systemd__unit_file('homeassistant.service').with_content(%r{^User=steve}) }
        it { should contain_systemd__unit_file('homeassistant.service').with_content(%r{^ExecStart=/foo/bin/hass -c "/etc/bar"}) }
        it { should contain_service('homeassistant').with_enable(true) }
      end
    end
  end
end
