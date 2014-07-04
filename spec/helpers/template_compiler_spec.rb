# -*- encoding : utf-8 -*-

require 'spec_helper'

SIMPLE_HTML = <<-HTML.freeze
<!DOCTYPE html>
<html>
    <head><title>title</title></head>
    <body></body>
</html>
HTML

ERB_HTML = <<-ERB.freeze
<!DOCTYPE html>
<html>
    <head><title>title</title></head>
    <body><%= "Hello, test!" %></body>
</html>
ERB

ERB_LAYOUT = <<-ERB.freeze
<!DOCTYPE html>
<html>
    <head><title>title</title></head>
    <body>
<% yield if block_given? %>
    </body>
</html>
ERB

def erb_template(layout_path)
  <<-ERB.freeze
<!-- content before -->
<% layout "#{layout_path}" do %>
    MAIN CONTENT HERE!
<% end %>
<!-- content after -->
  ERB
end

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

  context 'erb files:' do
    before :each do
      @tempfile = Tempfile.new(['template', '.html.erb'])
    end

    after :each do
      @tempfile.close
      @tempfile.unlink # deletes the temp file
    end

    it 'compile erb file' do
      result_html = ERB_HTML.dup.gsub!('<%= "Hello, test!" %>', 'Hello, test!')
      @tempfile.write ERB_HTML
      @tempfile.close
      expect(TemplateCompiler.compile(@tempfile.path, true)).to eq(result_html)
    end

    it 'compile template with layout' do
      @layout = Tempfile.new(['layout', '.html.erb'])
      @layout.write ERB_LAYOUT
      @layout.close

      template = erb_template(@layout.path)
      @tempfile.write template
      @tempfile.close

      arr = template.split("\n")
      layout = ERB_LAYOUT.split("<% yield if block_given? %>\n")
      arr[1] = layout[0].chomp!
      arr[3] = layout[1].chomp!

      result_html = arr.join("\n") << "\n"
      expect(TemplateCompiler.compile(@tempfile.path, true)).to eq(result_html)
    end
  end
end
