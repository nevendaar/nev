# -*- encoding : utf-8 -*-

# Pages helper
module PagesHelper

  D2_UNIT_ATTRS = {
      level:        'Уровень воина',
      expirience:   'Опыт',
      hp:           'Здоровье',
      armor:        'Броня',
      immune:       'Иммунитет',
      resist:       'Стойкость',
      weapon_type:  'Тип оружия',
      accuracy:     'Точность',
      damage:       'Повреждения',
      heal:         'Лечить', # TODO: более звучное название?
      damage_type:  'Тип атаки',
      # twice_attack: 'Двойная атака', # hidden
      initiative:   'Инициатива',
      targets:      'Зона поражения',
      target_count: 'Количество целей',
      leadership:   'Лидерство',
      moves:        'Скорость',
      skills:       'Навыки'
  }.each { |_k, v| v.freeze }.freeze

  D2_UNIT_IMMUNITIES = {
      disarmor: 'Разрушение брони',
      poison:   'Яд',
      weapon:   'Оружие',
      mind:     'Разум',
      life:     'Жизнь',
      death:    'Смерть',
      fire:     'Огонь',
      water:    'Вода',
      earth:    'Земля',
      air:      'Воздух'
  }.each { |_k, v| v.gsub!(' ', '&nbsp;'); v.freeze }.freeze

  D2_UNIT_TARGETS = {
      nearest: 'Ближайшие цели',
      all:     'Всё поле боя'
  }.each { |_k, v| v.freeze }.freeze

  D2_UNIT_SKILLS = {
      flying:    'Полёт',
      artefacts: 'Знание артефактов',
      scrolls:   'Посохи и свитки',
      spheres:   'Магия сфер',
      boots:     'Походное снаряжение',
      rod_hoist: 'Водрузить жезл'
  }.each { |_k, v| v.gsub!(' ', '&nbsp;'); v.freeze }.freeze

  def d2_unit_table(name, img_path, attrs = {}, unit_desc = '')
    locals = {unit_name: name, img_path: img_path, unit_attrs: attrs, unit_desc: unit_desc}
    render 'pages/index/partials/d2_unit_table.html.erb', locals: locals
  end

  def d2_unit_stat(attr_key, attrs)
    val = attrs[attr_key]
    return 'Нет' if val == :none
    case attr_key
      when :damage
        [val].flatten.join(' / ')
      when :damage_type
        [val].flatten.map { |v| D2_UNIT_IMMUNITIES[v] }.join(' / ')
      when :immune, :resist
        [val].flatten.uniq.map { |v| D2_UNIT_IMMUNITIES[v] }.join(', ')
      when :skills
        [val].flatten.uniq.map { |v| D2_UNIT_SKILLS[v] }.join(', ')
      when :expirience
        "0 / #{val}"
      when :accuracy
        [val].flatten.map { |v| "#{v}%" }.join(' / ')
      when :targets
        D2_UNIT_TARGETS[val]
      when :weapon_type
        [val].flatten.join(' / ') + (attrs[:twice_attack] ? ' <b>(x2)</b>' : '')
      else
        val
    end
  end
end
