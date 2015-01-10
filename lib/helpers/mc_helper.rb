# -*- encoding : utf-8 -*-

# Minichat helper
module MCHelper

  # TODO: move to config?
  MC_UPDATE_PERIODS = {
        0 => '--',
       15 => '15 сек',
       30 => '30 сек',
       60 => '1 мин',
      120 => '2 мин'
  }.each { |k, v| v.freeze }.freeze

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

  def autoupdate_selectbox
    wrap_whitespaces! do
      <<-HTML.gsub!(/ {2,}/, '').strip!
        <select id="mchatRSel" class="mchat" title="Автообновление">
        #{MC_UPDATE_PERIODS.map { |k, v| "<option value=\"#{k}\">#{v}</option>" }.join("\n")}
        </select>
      HTML
    end
  end

  def mc_message_field
    <<-HTML.gsub!(/\s+/, ' ').strip!
      <textarea id="mchatMsgF"
                name="mcmessage"
                class="mchat"
                title="Сообщение"
                placeholder="Сообщение"
                maxlength="#{ucoz_code '$MAX_MESSAGE_LEN$'}"
                required></textarea>
    HTML
  end
end
