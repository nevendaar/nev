# -*- encoding : utf-8 -*-

require 'spec_helper'

describe TemplateCompiler do

  context 'html files:' do
    before :all do
      @path       = 'spec/fixtures/plain.html'
      @plain_html = File.read(@path)
      # Always trim multiple "\n"
      @plain_html.gsub!(/\n\s*\n+/, "\n")
      @plain_html.freeze
    end

    it 'compile html file' do
      expect(TemplateCompiler.compile(@path, true)).to eq(@plain_html.byteslice(3..-1))
    end

    it 'trim utf-8 BOM' do
      token = TemplateCompiler.const_get(:BOM_TOKEN)
      expect(@plain_html.start_with?(token)).to eq(true)
      expect(TemplateCompiler.compile(@path, true).start_with?(token)).to eq(false)
    end

    it 'trim whitespaces by default' do
      trimmed_html = @plain_html.byteslice(3..-1)
      trimmed_html.gsub!(/ {2,}/, ' ') # Trim whitespaces
      expect(TemplateCompiler.compile(@path)).to eq(trimmed_html)
    end
  end

  context 'erb files:' do
    it 'compile erb file' do
      path = 'spec/fixtures/plain.html.erb'
      result_html = File.read(path).gsub!("<%= 'Hello, test!' %>", 'Hello, test!')
      expect(TemplateCompiler.compile(path, true)).to eq(result_html)
    end

    it 'compile template with layout' do
      layout_path = 'spec/fixtures/layout.html.erb'
      layout = File.read(layout_path)

      template_path = 'spec/fixtures/template.html.erb'
      template_html = File.read(template_path)

      arr = template_html.split("\n")
      layout = layout.split("<% yield if block_given? %>\n")
      arr[1] = layout[0].chomp!
      arr[3] = layout[1].chomp!

      result_html = arr.join("\n") << "\n"
      expect(TemplateCompiler.compile(template_path, true)).to eq(result_html)
    end

    it 'can render partial' do
      partial_path = 'spec/fixtures/_partial.html.erb'
      partial = File.read(partial_path).gsub!(/<%= @locals.* %>/, 'PARTIAL CONTENT')
      partial.chomp!.gsub!("\n", "\n#{' ' * 8}")

      template_path = 'spec/fixtures/template_with_partial.html.erb'
      template_html = File.read(template_path)

      arr = template_html.split(/<%= render .* %>/)
      result_html = [arr[0], partial, arr[1]].join
      expect(TemplateCompiler.compile(template_path, true)).to eq(result_html)
    end
  end

  describe 'wrap_whitespaces!' do

    before :each do
      @compiler = TemplateCompiler.new
      @compiler.instance_variable_set :@_erbout, '  text'
    end

    context 'with string' do
      it 'should keep indentation level' do
        str = @compiler.send :wrap_whitespaces!, "\nTEXT\n"
        expect(str).to eq "\n  TEXT\n  "
      end
      it 'not modify @_erbout' do
        @compiler.send :wrap_whitespaces!, "\nTEXT\n"
        expect(@compiler.instance_variable_get(:@_erbout)).to eq '  text'
      end
    end

    context 'with block' do
      it 'should keep indentation level' do
        str = @compiler.send(:wrap_whitespaces!) { "\nTEXT\n" }
        expect(str).to eq "\n  TEXT\n  "
      end
      it 'not modify @_erbout' do
        @compiler.send(:wrap_whitespaces!) { "\nTEXT\n" }
        expect(@compiler.instance_variable_get(:@_erbout)).to eq '  text'
      end
    end
  end
end
