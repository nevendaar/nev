# -*- encoding : utf-8 -*-

class Helper

  RANK_DIR = '/Forumdata/Rank/Ranks'.freeze
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

  def group_is(code, key_or_group, *groups)
    not_flag = (key_or_group == :not)
    operator = not_flag ? '!=' : '='
    l_groups = not_flag ? groups : [key_or_group].push(*groups)
    result = l_groups.each_with_object([]) do |group, arr|
      arr << "#{code}#{operator}#{USER_GROUPS[group.to_sym]}"
    end.join(not_flag ? ' && ' : ' || ')
    l_groups.size > 1 ? "(#{result})" : result
  end

  # Вырезаем из строки ранг и проводим к целому.
  def user_rank
    # $USER_RANK_ICON$ = '<img alt="" name="rankimg" border="0" src="http://nevendaar.com/Forumdata/Rank/Ranks/rank10.gif" align="absmiddle" />'
    "<? 0 + substr($USER_RANK_ICON$, #{home_url.size + RANK_DIR.size + 48}, 2) ?>"
  end

  def first_post
    "substr($NUMBER$,-6,3)='>1<'"
  end

  def not_first_post
    "substr($NUMBER$,-6,3)!='>1<'"
  end

  def not_new_on_the_site_tread
    '$TID$!=1647'
  end

  def not_lucky_pub_tread
    '$TID$!=699'
  end

  def role_game_section
    %w[6 8 9 10 11 12 31].each_with_object([]) do |id, arr|
      arr << "$FID$=#{id}"
    end.join(' || ')
  end

  def moder_names
    nicks = %w(Вансан Гангрен vertus SoCrat Пророк Вильгельм Sqwall Hierophant FairYng Inno Mystique Химера Город)
    nicks.each_with_object([]) do |name, arr|
      str = "#{name}<"
      arr << "substr($EDITEDBY$,23,#{str.size})='#{str}'"
    end.join(' || ')
  end

  def layout(template = :main)
    template = File.read("templates/layouts/#{template}.html.erb").chomp!
    erbout = @_erbout.dup
    str = ERB.new(template, nil, nil, '@_erbout').result(binding)
    @_erbout = (erbout << str)
  end
end
