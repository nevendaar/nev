# -*- encoding : utf-8 -*-

module ForumHelper

  RANK_DIR = '/Forumdata/Rank/Ranks'.freeze

  # Вырезаем из строки ранг и проводим к целому.
  def user_rank
    # $USER_RANK_ICON$ = '<img alt="" name="rankimg" border="0" src="http://nevendaar.com/Forumdata/Rank/Ranks/rank10.gif" align="absmiddle" />'
    "<? 0 + substr($USER_RANK_ICON$, #{home_url.size + RANK_DIR.size + 48}, 2) ?>"
  end

  def first_post(_not = nil)
    vals = ["'>1<'"]
    vals.unshift(_not) if _not == :not
    code_is('substr($NUMBER$,-6,3)', *vals)
  end

  def not_new_on_the_site_tread
    code_is '$TID$', :not, 1647
  end

  def not_lucky_pub_tread
    code_is '$TID$', :not, 699
  end

  def role_game_section(_not = nil)
    ids = %w[6 8 9 10 11 12 31]
    ids.unshift(_not) if _not == :not
    code_is('$FID$', *ids)
  end

  def moder_names
    nicks = %w(Вансан Гангрен vertus SoCrat Пророк Вильгельм Sqwall Hierophant FairYng Inno Mystique Химера Город)
    result = nicks.each_with_object([]) do |name, arr|
      str = "#{name}<"
      arr << "substr($EDITEDBY$,23,#{str.size})='#{str}'"
    end.join(' || ')
    nicks.size > 1 ? "(#{result})" : result
  end
end
