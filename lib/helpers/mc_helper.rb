# -*- encoding : utf-8 -*-

# Minichat helper
module MCHelper

  # Вырезаем из кода $CHAT_BOX$ форму.
  def minichat_form
    # strpos ищет вхождение только в первой 1000 символов, поэтому сразу найти
    # <form> не удастся. Для корректного поиска мы с некоторым отступом
    # выделим подстроку.
    offset = 700
    form_end_tag = '</form>'
    form_start_pos = "strpos(substr($CHAT_BOX$, #{offset}), '<form') + #{offset}"
    form_end_pos = "strrpos($CHAT_BOX$, '#{form_end_tag}') - (#{form_start_pos}) + #{form_end_tag.size}"
    ucoz_injection "substr($CHAT_BOX$, #{form_start_pos}, #{form_end_pos})"
  end
end
