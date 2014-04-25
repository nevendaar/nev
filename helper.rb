# -*- encoding : utf-8 -*-

class Helper

  def initialize(hash = {})
    @params = hash
    @params[:meta] = {}
    @_erbout = nil
  end

  def get_binding
    binding
  end

  def charset_and_ie_support_tags
    s = <<-HTML
      <meta charset="utf-8">
      <!--[if lt IE 9]><script src="/js/html5.js"></script><![endif]-->
    HTML
    s.chomp!
  end

  def meta_tags
    s = ''
    @params[:meta].each do |name, content|
      s << <<-HTML
        <meta name="#{name}" content="#{content}">
      HTML
    end
    s.chomp!
  end

  def stylesheet_link_tag
    '<link href="/css/app.css" rel="stylesheet">'
  end

  def javascript_include_tag
    '<script src="/js/app.js"></script>'
  end

  def layout(template = :main)
    template = File.read("templates/layouts/#{template}.html.erb").chomp!
    erbout = @_erbout.dup
    str = ERB.new(template, nil, nil, '@_erbout').result(binding)
    @_erbout = (erbout << str)
  end
end
