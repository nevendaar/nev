# -*- encoding : utf-8 -*-

class Helper

  # def initialize(hash = {})
  #   hash.each do |key, value|
  #     singleton_class.send(:define_method, key) { value }
  #   end
  # end

  def get_binding
    binding
  end

  def charset_and_ie_support_tags
    s = <<-HTML
      <meta charset="utf-8">
      <!--[if lt IE 9]><script src="/js/html5.js"></script><![endif]-->
    HTML
    s.chomp
  end

  def stylesheet_link_tag
    '<link href="/css/app.css" rel="stylesheet">'
  end

  def javascript_include_tag
    '<script src="/js/app.js"></script>'
  end
end
