# -*- encoding : utf-8 -*-

require 'spec_helper'

describe TemplateCompiler do
  it 'have class method #config' do
    expect(TemplateCompiler.config).to eq AppConfig.config
  end
  it 'have instance method #config' do
    expect(TemplateCompiler.new.config).to eq AppConfig.config
  end
end
