# -*- encoding : utf-8 -*-

require 'spec_helper'

describe UcozHelper do

  before :each do
    @dummy_class = Class.new do
      extend UcozHelper
      @cond_operators = []
      @_erbout = '  test'
    end
  end

  describe 'code_is' do
    it 'should work with one argument' do
      expect(@dummy_class.code_is('$TEST$', 5)).to eq('$TEST$=5')
    end

    it 'should work with multiple arguments' do
      result = @dummy_class.code_is('$TEST$', 5, "'hello'", 7)
      expect(result).to eq("($TEST$=5 || $TEST$='hello' || $TEST$=7)")
    end

    it 'support != condition' do
      expect(@dummy_class.code_is('$TEST$', :not, 5)).to eq('$TEST$!=5')
    end

    it 'support != condition with multiple arguments' do
      result = @dummy_class.code_is('$TEST$', :not, 5, "'hello'", 7)
      expect(result).to eq("($TEST$!=5 && $TEST$!='hello' && $TEST$!=7)")
    end

    it 'can work with block' do
      result = @dummy_class.code_is('$TEST$', 5) do |val|
        "'Say: #{val}'"
      end
      expect(result).to eq("$TEST$='Say: 5'")
    end
  end

  describe 'group_is' do
    it 'should work with symbol values' do
      result = @dummy_class.group_is('$GROUP$', :user, :admin)
      expect(result).to eq("($GROUP$=#{UcozHelper::USER_GROUPS[:user]} || $GROUP$=#{UcozHelper::USER_GROUPS[:admin]})")
    end

    it 'support != condition' do
      result = @dummy_class.group_is('$GROUP$', :not, :moderator)
      expect(result).to eq("$GROUP$!=#{UcozHelper::USER_GROUPS[:moderator]}")
    end
  end

  %w[ucoz_injection i].each do |method_name|
    describe method_name do
      it 'wrap given code' do
        result = @dummy_class.send method_name, '$CODE$'
        expect(result).to eq('<?$CODE$?>')
      end
    end
  end

  describe 'ucoz_if' do
    it "add 'if' statement to self out" do
      @dummy_class.ucoz_if('true')
      out_str = @dummy_class.instance_variable_get(:@_erbout)
      expect(out_str).to eq '  test<?if(true)?>'
    end

    it 'support multiple conditions' do
      @dummy_class.ucoz_if('true', 'false')
      out_str = @dummy_class.instance_variable_get(:@_erbout)
      expect(out_str).to eq '  test<?if(true && false)?>'
    end

    it 'yield given block' do
      out_str = @dummy_class.instance_variable_get(:@_erbout)
      @dummy_class.ucoz_if('true') { out_str << 'SECRET' }
      expect(out_str).to eq '  test<?if(true)?>SECRET'
    end

    it 'returns UcozConditionStatement' do
      expect(@dummy_class.ucoz_if('true')).to be_a_kind_of UcozConditionStatement
    end

    it 'fill up @cond_operators array' do
      statement = @dummy_class.ucoz_if('true')
      cond_operators = @dummy_class.instance_variable_get(:@cond_operators)
      expect(cond_operators.last).to be statement
    end

    it "can don't modify self out buffer" do
      out_str = ''
      self_buffer = @dummy_class.instance_variable_get(:@_erbout).dup
      @dummy_class.ucoz_if('true', :options => {:out_str => out_str})
      expect(out_str).to eq '<?if(true)?>'
      expect(@dummy_class.instance_variable_get(:@_erbout)).to eq self_buffer
    end

    it 'have alias method #uif' do
      expect(@dummy_class.method(:uif)).to eq @dummy_class.method(:ucoz_if)
    end
  end
end
