# -*- encoding : utf-8 -*-

require 'spec_helper'

shared_examples 'config parameter' do |parameter, value|
  before(:all) { @config = AppConfig.config }
  it 'configured via config block' do
    old_config = @config.send(parameter)
    AppConfig.configure {|c| c.send("#{parameter}=", value)}
    expect(@config.send(parameter)).to eq value
    AppConfig.configure {|c| c.send("#{parameter}=", old_config)}
  end
end

describe AppConfig do
  describe 'home_url' do
    it_behaves_like 'config parameter', 'home_url', 'http://example.com'
  end
end
