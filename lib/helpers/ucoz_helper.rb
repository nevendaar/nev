# -*- encoding : utf-8 -*-

require_relative '../ucoz_condition_statement'

module UcozHelper

  USER_GROUPS = {
      :user       => 1,
      :trusted    => 2,
      :moderator  => 3,
      :admin      => 4,
      :hex_studio => 13,
      :master     => 14,
      :imp_form   => 15,
      :lord       => 251,
      :banned     => 255
  }.freeze

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
    code_is(code, key_or_group, *groups) { |v| USER_GROUPS[v.to_sym] }
  end

  def ucoz_code(code)
    # TODO: if environment == :test
    code
  end
  alias_method :c, :ucoz_code

  def ucoz_injection(code)
    # TODO: if environment == :test
    "<?#{code}?>"
  end
  alias_method :i, :ucoz_injection

  def ucoz_if(*args, options: {}, &block)
    conditions = args.flatten
    statement = UcozConditionStatement.new(@_erbout, *conditions, options, &block)
    @cond_operators << statement
    statement
  end

  def ucoz_ifnot(*conditions, &block)
    ucoz_if(*conditions, :options => {:not_flag => true}, &block)
  end

  def inline_if(*conditions, &block)
    ucoz_if(*conditions, :options => {:inline => true}, &block)
  end

  def inline_ifnot(*conditions, &block)
    ucoz_if(*conditions, :options => {:not_flag => true, :inline => true}, &block)
  end

  def unclosed_conditions
    @cond_operators.count { |c| !c.closed? }
  end

  def check_conditions!
    if unclosed_conditions > 0
      LOGGER.error "Template have #{unclosed_conditions} unclosed 'if' ('ifnot') operator#{'s' if unclosed_conditions > 1}"
      raise RuntimeError # TODO: create error class
    end
  end
end
