# -*- encoding : utf-8 -*-

class Helper

  def initialize(hash = {})
    @params = hash
  end

  def keys
    @params.keys
  end

  def values
    @params.values
  end

  def to_binding(object = Helper.new)
    object.instance_eval("def binding_for(#{keys.join(",")}) binding end")
    block = block_given? ? Proc.new : nil
    object.binding_for(*values, &block)
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

  def layout(name = nil)
    template = File.read('/home/kia84/projects/nev/templates/layouts/main.html.erb')
    previous = ERB.new(yield).result(self.to_binding)
    context = self.to_binding { previous }
    ERB.new(template).result(context)
  end
end
