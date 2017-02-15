require 'spec_helper'
describe 'homeassistant' do

  context 'with defaults for all parameters' do
    it { should contain_class('homeassistant') }
  end
end
