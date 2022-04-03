# frozen_string_literal: true

require 'spec_helper'
describe 'homeassistant' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(python3_version: '3.5')
      end

      context 'with non optional parameters set' do
        let(:params) do
          {
            location_name: 'My Home',
            latitude: 23.4,
            longitude: -14.7,
            elevation: 76,
            unit_system: 'metric',
            time_zone: 'Europe/Paris'
          }
        end

        it { is_expected.to contain_class('homeassistant') }
        it { is_expected.to contain_user('homeassistant').with_home('/srv/homeassistant') }
        it { is_expected.to contain_user('homeassistant').with_system(true) }
        it { is_expected.to contain_user('homeassistant').with_gid('homeassistant') }
        it { is_expected.to contain_group('homeassistant').with_system(true) }
        it { is_expected.to contain_file('/etc/homeassistant').with_ensure('directory') }
        it { is_expected.to contain_file('/etc/homeassistant').with_owner('homeassistant') }
        it { is_expected.to contain_class('python') }
        it { is_expected.to contain_python__pyvenv('/srv/homeassistant') }
        it { is_expected.to contain_systemd__unit_file('homeassistant.service').with_content(%r{^User=homeassistant}) }
        it { is_expected.to contain_systemd__unit_file('homeassistant.service').with_content(%r{^ExecStart=/srv/homeassistant/bin/hass -c "/etc/homeassistant"}) }
        it { is_expected.to contain_systemd__unit_file('homeassistant.service').with_content(%r{^Environment=PATH="/srv/homeassistant/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"}) }
        it { is_expected.to contain_service('homeassistant').with_enable(true) }
        it { is_expected.to contain_concat('configuration.yaml').with_path('/etc/homeassistant/configuration.yaml') }
        it { is_expected.to contain_concat__fragment('homeassistant').with_target('configuration.yaml') }
        it { is_expected.to contain_concat__fragment('homeassistant').with_content(%r{^  name: My Home$}) }
        it { is_expected.to contain_concat__fragment('homeassistant').with_content(%r{^  latitude: 23.4$}) }
        it { is_expected.to contain_concat__fragment('homeassistant').with_content(%r{^  longitude: -14.7$}) }
        it { is_expected.to contain_concat__fragment('homeassistant').with_content(%r{^  elevation: 76$}) }
        it { is_expected.to contain_concat__fragment('homeassistant').with_content(%r{^  unit_system: metric$}) }
        it { is_expected.to contain_concat__fragment('homeassistant').with_content(%r{^  time_zone: Europe/Paris$}) }
      end

      context 'with all parameters set' do
        let(:params) do
          {
            location_name: 'My Home',
            latitude: 23.4,
            longitude: -14.7,
            elevation: 76,
            unit_system: 'metric',
            time_zone: 'Europe/Paris',
            home: '/foo',
            confdir: '/etc/bar'
          }
        end

        it { is_expected.to contain_file('/etc/bar').with_ensure('directory') }
        it { is_expected.to contain_file('/etc/bar').with_owner('homeassistant') }
        it { is_expected.to contain_class('python') }
        it { is_expected.to contain_python__pyvenv('/foo') }
        it { is_expected.to contain_systemd__unit_file('homeassistant.service').with_content(%r{^User=homeassistant}) }
        it { is_expected.to contain_systemd__unit_file('homeassistant.service').with_content(%r{^ExecStart=/foo/bin/hass -c "/etc/bar"}) }
        it { is_expected.to contain_service('homeassistant').with_enable(true) }
        it { is_expected.to contain_concat('configuration.yaml').with_path('/etc/bar/configuration.yaml') }
        it { is_expected.to contain_concat__fragment('homeassistant').with_target('configuration.yaml') }
        it { is_expected.to contain_concat__fragment('homeassistant').with_content(%r{^  name: My Home$}) }
      end
    end
  end
end
