# -*- encoding : utf-8 -*-

require_relative 'helpers/forum_helper'

class Helper

  include ForumHelper

  USER_GROUPS = {
      :master    => 14,
      :admin     => 4,
      :moderator => 3,
      :banned    => 255,
      :user      => 1
  }

  def initialize(hash = {})
    @params = hash
    @params[:meta]     = {}
    @params[:vk]       = {}
    @params[:redirect] = {}
    @_erbout = nil
  end

  def get_binding
    binding
  end

  def home_url
    'http://nevendaar.com'
  end

  def charset_and_ie_support_tags
    <<-HTML.chomp!
      <meta charset="utf-8">
      <!--[if lt IE 9]><script src="/js/html5.min.js"></script><![endif]-->
    HTML
  end

  def meta_redirect_to
    if @params[:redirect][:path]
      <<-HTML
        <meta http-equiv="refresh" content="0; url=#{@params[:redirect][:path]}">
        <script type="text/javascript">location.replace("#{home_url}#{@params[:redirect][:path]}");</script>
      HTML
    end
  end

  def meta_tags
    s = meta_redirect_to.to_s
    @params[:meta].each do |name, content|
      s << <<-HTML
        <meta name="#{name}" content="#{content}">
      HTML
    end
    s.chomp!
  end

  def stylesheet_link_tag
    '<link href="/css/app.min.css" rel="stylesheet">'
  end

  def javascript_include_tag
    '<script src="/js/app.js"></script>'
  end

  def vk_like_btn
    '<div id="vk_like" class="pull-left"></div>'
  end

  def vk_comments_box(uid)
    "<div class=\"VKborders\"><div id=\"vk_comments\" data-uid=\"#{uid}\"></div></div>"
  end

  def code_is(code, key_or_value, *values)
    not_flag = (key_or_value == :not)
    operator = not_flag ? '!=' : '='
    l_values = not_flag ? values : [key_or_value].push(*values)
    result = l_values.each_with_object([]) do |val, arr|
      arr << "#{code}#{operator}#{block_given? ? yield(val) : val}"
    end.join(not_flag ? ' && ' : ' || ')
    l_values.size > 1 ? "(#{result})" : result
  end

  def group_is(code, key_or_group, *groups)
    code_is(code, key_or_group, *groups){|v| USER_GROUPS[v.to_sym] }
  end

  def layout(template = :main)
    template = File.read("templates/layouts/#{template}.html.erb").chomp!
    erbout = @_erbout.dup
    str = ERB.new(template, nil, nil, '@_erbout').result(binding)
    @_erbout = (erbout << str)
  end
end
