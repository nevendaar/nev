# -*- encoding : utf-8 -*-

module UserHelper
  USER_ENTRIES = {
      com:   'комментарии',
      forum: 'форум',
      blog:  'фан-творчество',
      news:  'новости',
      publ:  'статьи',
      load:  'файлы',
      # dir: 'ссылки',
      board: 'объявления',
      photo: 'изображения'
  }.each { |k, v| v.freeze }.freeze

  def rank_name(rank_id, msn_id, rank_name, gender_code)
    r_class = ucoz_if_str(msn_id) do |s|
      # Base rank name
      s << " rank-#{ucoz_code rank_id}-#{ucoz_code msn_id}"
      s << ucoz_if_str(female gender_code) do |str|
        # Female rank name
        str << " rank-#{ucoz_code rank_id}-#{ucoz_code msn_id}-f"
      end.endif!
    end.endif!
    "<span class=\"rank#{r_class}\" data-rank-name=\"#{ucoz_code rank_name}\"></span>"
  end

  def user_entries(partial)
    USER_ENTRIES.each_with_object('') do |(key, val), result|
      result << render(partial, locals: {entry_type: key, entry_name: val})
    end
  end
end
