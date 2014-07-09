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
  }

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

  # TODO: multiple conditions
  def ucoz_if(condition, &block)
    statement = UcozConditionStatement.new(condition, @_erbout, &block)
    @cond_operators << statement
    statement
  end

  def ucoz_ifnot(condition, &block)
    statement = UcozConditionStatement.new(condition, @_erbout, :not_flag => true, &block)
    @cond_operators << statement
    statement
  end

  def inline_if(condition, &block)
    statement = UcozConditionStatement.new(condition, @_erbout, :inline => true, &block)
    @cond_operators << statement
    statement
  end

  def inline_ifnot(condition, &block)
    statement = UcozConditionStatement.new(condition, @_erbout, :not_flag => true, :inline => true, &block)
    @cond_operators << statement
    statement
  end

  def unclosed_conditions
    @cond_operators.count { |c| !c.closed? }
  end
end
