# -*- encoding : utf-8 -*-

require 'spec_helper'

describe UcozConditionStatement do

  context 'if()' do

    it "add 'if' statement to out" do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true')
      expect(outstr).to eq 'content<?if(true)?>'
    end

    it 'support multiple conditions' do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true', 'false')
      expect(outstr).to eq 'content<?if(true && false)?>'
    end

    it 'yield given block' do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true') { outstr << 'SECRET' }
      expect(outstr).to eq 'content<?if(true)?>SECRET'
    end

    it 'unclosed' do
      statement = UcozConditionStatement.new('', 'true')
      expect(statement.closed?).to eq false
    end
  end

  context 'ifnot()' do

    it "add 'ifnot' statement to out" do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true', :not_flag => true)
      expect(outstr).to eq 'content<?ifnot(true)?>'
    end

    it 'support multiple conditions' do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true', 'false', :not_flag => true)
      expect(outstr).to eq 'content<?ifnot(true || false)?>'
    end

    it 'yield given block' do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true', :not_flag => true) { outstr << 'SECRET' }
      expect(outstr).to eq 'content<?ifnot(true)?>SECRET'
    end

    it 'unclosed' do
      statement = UcozConditionStatement.new('', 'true', :not_flag => true)
      expect(statement.closed?).to eq false
    end
  end

  context 'else()' do

    it 'return self' do
      statement = UcozConditionStatement.new('', 'true')
      else_statement = statement.else
      expect(statement).to eq else_statement
    end

    it 'return self with block' do
      statement = UcozConditionStatement.new('', 'true')
      else_statement = statement.else {}
      expect(statement).to eq else_statement
    end

    it "add 'else' statement to out" do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true') { outstr << 'SECRET' }.else
      expect(outstr).to eq 'content<?if(true)?>SECRET<?else?>'
    end

    it 'yield given block' do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true') {
        outstr << 'SECRET'
      }.else {
        outstr << 'ELSE_SECRET'
      }
      expect(outstr).to eq 'content<?if(true)?>SECRET<?else?>ELSE_SECRET'
    end

    it 'should print WARN log with ifnot()' do
      expect(LOGGER).to receive(:warn).with(UcozConditionStatement::PROG_NAME)
      UcozConditionStatement.new('', 'true', :not_flag => true).else
    end

    it 'unclosed' do
      statement = UcozConditionStatement.new('', 'true').else
      expect(statement.closed?).to eq false
    end

    it 'raise error with two else()' do
      expect(LOGGER).to receive(:error).with(UcozConditionStatement::PROG_NAME)
      statement = UcozConditionStatement.new('', 'true').else
      expect { statement.else }.to raise_error(RuntimeError)
    end
  end

  context 'endif!()' do

    it 'return string' do
      outstr = ''
      statement = UcozConditionStatement.new(outstr, 'true').endif!
      expect(statement).to be outstr # comparing objects here
    end

    it "add 'endif' statement to out" do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true') { outstr << 'SECRET' }.endif!
      expect(outstr).to eq 'content<?if(true)?>SECRET<?endif?>'
    end

    it 'work with else() too' do
      outstr = 'content'
      UcozConditionStatement.new(outstr, 'true') {
        outstr << 'SECRET'
      }.else {
        outstr << 'ELSE_SECRET'
      }.endif!
      expect(outstr).to eq 'content<?if(true)?>SECRET<?else?>ELSE_SECRET<?endif?>'
    end

    it 'closed' do
      statement = UcozConditionStatement.new('', 'true')
      statement.endif!
      expect(statement.closed?).to eq true
    end

    it 'raise error with two endif!()' do
      expect(LOGGER).to receive(:error).with(UcozConditionStatement::PROG_NAME)
      statement = UcozConditionStatement.new('', 'true')
      statement.endif!
      expect { statement.endif! }.to raise_error(RuntimeError)
    end

    it 'check conditions, which can be simplified' do
      expect(LOGGER).to receive(:warn).with(UcozConditionStatement::PROG_NAME)
      statement = UcozConditionStatement.new('', '$CODE$'){ |s| s << "\n\t   $CODE$\n    " }
      statement.endif!
      expect(statement.instance_variable_get(:@can_simplify)).to eq true
    end
  end
end
