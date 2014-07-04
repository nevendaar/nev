# -*- encoding : utf-8 -*-

require 'spec_helper'

SIMPLE_HTML = <<-HTML.freeze
<!DOCTYPE html>
<html>
    <head><title>title</title></head>
    <body></body>
</html>
HTML

describe TemplateCompiler do

  context 'html files:' do

    before :each do
      @tempfile = Tempfile.new(['template', '.html'])
    end

    after :each do
      @tempfile.close
      @tempfile.unlink # deletes the temp file
    end

    it 'compile html file' do
      @tempfile.write SIMPLE_HTML
      @tempfile.close
      expect(TemplateCompiler.compile(@tempfile.path, true)).to eq(SIMPLE_HTML)
    end

    it 'trim utf-8 BOM' do
      @tempfile.write "#{TemplateCompiler.const_get(:BOM_TOKEN)}#{SIMPLE_HTML}"
      @tempfile.close
      expect(TemplateCompiler.compile(@tempfile.path, true)).to eq(SIMPLE_HTML)
    end

    it 'trim whitespaces by default' do
      trimmed_html = SIMPLE_HTML.dup
      trimmed_html.gsub!(/\n\s*\n+/, "\n") # Trim multiple "\n"
      trimmed_html.gsub!(/ {2,}/, ' ') # Trim whitespaces
      @tempfile.write "#{SIMPLE_HTML}#{"\n" * 5}"
      @tempfile.close
      expect(TemplateCompiler.compile(@tempfile.path)).to eq(trimmed_html)
    end
  end
end
