# -*- encoding : utf-8 -*-

require 'spec_helper'

describe UserHelper do

  before :each do
    @dummy_class = Class.new do
      extend UcozHelper
      extend UserHelper
      @cond_operators = []
      @_erbout = '  test'

      def self.config
        AppConfig.config
      end
    end
  end

  describe 'rank_name' do
    it 'should return html-string' do
      result = @dummy_class.rank_name('$_RANK$', '$_MSN$', '$_RANK_NAME$', '$_GENDER_ID$')
      expected_result = <<-HTML.chomp!
<span class="rank<?if($_MSN$)?> rank-$_RANK$-$_MSN$<?if($_GENDER_ID$=2)?> rank-$_RANK$-$_MSN$-f<?endif?><?endif?>" data-rank-name="$_RANK_NAME$"></span>
      HTML
      expect(result).to eq(expected_result)
    end

    it "don't modify out buffer" do
      self_buffer = @dummy_class.instance_variable_get(:@_erbout).dup
      @dummy_class.rank_name('RID', 'MSN', 'RN', 'GID')
      expect(@dummy_class.instance_variable_get(:@_erbout)).to eq self_buffer
    end
  end
end
