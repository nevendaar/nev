# -*- encoding : utf-8 -*-

require 'spec_helper'

describe UcozConditionStatement do

  context 'if()' do

    it "add 'if' statement to out" do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr)
      expect(outstr).to eq "content<?if(true)?>\n"
    end

    it 'can be inline' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :inline => true)
      expect(outstr).to eq 'content<?if(true)?>'
    end

    it 'yield given block' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr) { outstr << 'SECRET' }
      expect(outstr).to eq "content<?if(true)?>\nSECRET"
    end

    it 'can be inline with block' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :inline => true) do
        outstr << 'SECRET'
      end
      expect(outstr).to eq 'content<?if(true)?>SECRET'
    end

    it 'unclosed' do
      statement = UcozConditionStatement.new('true', '')
      expect(statement.closed?).to eq false
    end
  end

  context 'ifnot()' do

    it "add 'ifnot' statement to out" do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :not_flag => true)
      expect(outstr).to eq "content<?ifnot(true)?>\n"
    end

    it 'can be inline' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :not_flag => true, :inline => true)
      expect(outstr).to eq 'content<?ifnot(true)?>'
    end

    it 'yield given block' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :not_flag => true) { outstr << 'SECRET' }
      expect(outstr).to eq "content<?ifnot(true)?>\nSECRET"
    end

    it 'can be inline with block' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :not_flag => true, :inline => true) do
        outstr << 'SECRET'
      end
      expect(outstr).to eq 'content<?ifnot(true)?>SECRET'
    end

    it 'unclosed' do
      statement = UcozConditionStatement.new('true', '', :not_flag => true)
      expect(statement.closed?).to eq false
    end
  end

  context 'else()' do

    it 'return self' do
      statement = UcozConditionStatement.new('true', '')
      else_statement = statement.else
      expect(statement).to eq else_statement
    end

    it 'return self with block' do
      statement = UcozConditionStatement.new('true', '')
      else_statement = statement.else {}
      expect(statement).to eq else_statement
    end

    it "add 'else' statement to out" do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr) { outstr << 'SECRET' }.else
      expect(outstr).to eq "content<?if(true)?>\nSECRET<?else?>\n"
    end

    it 'can be inline' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :inline => true) do
        outstr << 'SECRET'
      end.else
      expect(outstr).to eq 'content<?if(true)?>SECRET<?else?>'
    end

    it 'yield given block' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr) {
        outstr << 'SECRET'
      }.else {
        outstr << 'ELSE_SECRET'
      }
      expect(outstr).to eq "content<?if(true)?>\nSECRET<?else?>\nELSE_SECRET"
    end

    it 'can be inline with block' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :inline => true) {
        outstr << 'SECRET'
      }.else {
        outstr << 'ELSE_SECRET'
      }
      expect(outstr).to eq 'content<?if(true)?>SECRET<?else?>ELSE_SECRET'
    end

    it 'should print WARN log with ifnot()' do
      expect(LOGGER).to receive(:warn).with('ifnot used with else')
      UcozConditionStatement.new('true', '', :not_flag => true).else
    end

    it 'unclosed' do
      statement = UcozConditionStatement.new('true', '').else
      expect(statement.closed?).to eq false
    end

    it 'raise error with two else()' do
      expect(LOGGER).to receive(:error).with('if operator have multiple else blocks!')
      statement = UcozConditionStatement.new('true', '').else
      expect { statement.else }.to raise_error(RuntimeError)
    end
  end

  context 'endif!()' do

    it 'return nil' do
      statement = UcozConditionStatement.new('true', '').endif!
      expect(statement).to be_nil
    end

    it "add 'endif' statement to out" do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr) { outstr << 'SECRET' }.endif!
      expect(outstr).to eq "content<?if(true)?>\nSECRET<?endif?>\n"
    end

    it 'can be inline' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :inline => true) do
        outstr << 'SECRET'
      end.endif!
      expect(outstr).to eq 'content<?if(true)?>SECRET<?endif?>'
    end

    it 'work with else() too' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr) {
        outstr << 'SECRET'
      }.else {
        outstr << 'ELSE_SECRET'
      }.endif!
      expect(outstr).to eq "content<?if(true)?>\nSECRET<?else?>\nELSE_SECRET<?endif?>\n"
    end

    it 'work with inline else() too' do
      outstr = 'content'
      UcozConditionStatement.new('true', outstr, :inline => true) {
        outstr << 'SECRET'
      }.else {
        outstr << 'ELSE_SECRET'
      }.endif!
      expect(outstr).to eq 'content<?if(true)?>SECRET<?else?>ELSE_SECRET<?endif?>'
    end

    it 'closed' do
      statement = UcozConditionStatement.new('true', '')
      statement.endif!
      expect(statement.closed?).to eq true
    end

    it 'raise error with two endif!()' do
      expect(LOGGER).to receive(:error).with('if operator already closed!')
      statement = UcozConditionStatement.new('true', '')
      statement.endif!
      expect { statement.endif! }.to raise_error(RuntimeError)
    end
  end
end
