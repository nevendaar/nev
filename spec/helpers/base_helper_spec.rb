# -*- encoding : utf-8 -*-

require 'spec_helper'

describe BaseHelper do

  before :each do
    @compiler = TemplateCompiler.new
    @compiler.instance_variable_set :@_erbout, '  text'
  end

  describe 'remove_admin_bar!' do
    it 'should modify @_erbout' do
      @compiler.remove_admin_bar!
      expect(@compiler.instance_variable_get(:@_erbout)).to eq '  text<?substr($ADMIN_BAR$, 0, 0)?>'
    end

    it 'should return nil' do
      expect(@compiler.remove_admin_bar!).to be_nil
    end
  end
end
