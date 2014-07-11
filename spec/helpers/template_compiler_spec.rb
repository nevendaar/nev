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
      expect(TemplateCompiler.compile(@path, true)).to eq(@plain_html)
    end

    it 'trim utf-8 BOM' do
      token = TemplateCompiler.const_get(:BOM_TOKEN)
      expect(TemplateCompiler.compile(@path, true).start_with?(token)).to eq(false)
    end

    it 'trim whitespaces by default' do
      trimmed_html = @plain_html.dup
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
  end
end
