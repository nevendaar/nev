# -*- encoding : utf-8 -*-

require 'spec_helper'

describe UcozHelper do

  before :each do
    @dummy_class = Class.new do
      extend UcozHelper
      @cond_operators = []
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
end
