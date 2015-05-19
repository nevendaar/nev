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

  def female(code = '$USER_GENDER_ID$')
    code_is code, 2
  end

  def ucoz_code(code)
    message = config.deprecated_codes[code]
    LOGGER.warn('ucoz_code') do
      "Code '#{code}' is deprecated.\n#{message.chomp}"
    end if message
    if config.env == :test
      paths = %W[
        spec/fixtures/#{@module_name}/#{@template_name}/#{code}.html.erb
        spec/fixtures/#{@module_name}/#{code}.html.erb
        spec/fixtures/globals/#{code}.html.erb
        spec/fixtures/defaults/#{code}.html.erb
      ]
      result = nil
      paths.each do |path|
        if File.exist?(path)
          result = render path
          break
        end
      end
      if result.nil?
        LOGGER.warn('ucoz_code') { "Cannot find fixture for code: '#{code}'." }
        LOGGER.debug('ucoz_code') { "Searched in:\n#{paths.join("\n")}" }
      end
      result || code
    else
      code
    end
  end
  alias_method :c, :ucoz_code

  def ucoz_injection(code)
    # TODO: if environment == :test
    "<?#{code}?>"
  end
  alias_method :i, :ucoz_injection

  def ucoz_if(*args, options: {}, &block)
    conditions = args.flatten
    out_str = options.delete(:out_str) || @_erbout
    statement = UcozConditionStatement.new(out_str, *conditions, options, &block)
    @cond_operators << statement
    statement
  end
  alias_method :uif, :ucoz_if

  def ucoz_ifnot(*conditions, &block)
    ucoz_if(*conditions, :options => {:not_flag => true}, &block)
  end
  alias_method :uifnot, :ucoz_ifnot

  def ucoz_if_str(*conditions, &block)
    ucoz_if(*conditions, :options => {:out_str => ''}, &block)
  end
  alias_method :uif_str, :ucoz_if_str

  def ucoz_ifnot_str(*conditions, &block)
    ucoz_if(*conditions, :options => {:out_str => '', :not_flag => true}, &block)
  end
  alias_method :uifnot_str, :ucoz_ifnot_str

  # TODO: Add test!
  def u_default(code, default)
    ucoz_if_str(code){ |s| s << code }.else { |s| s << default }.endif!
  end

  def unclosed_conditions
    @cond_operators.count { |c| !c.closed? }
  end

  def check_conditions!
    count = unclosed_conditions
    if count > 0
      LOGGER.error('template_compiler') do
        "Template have #{count} unclosed 'if' ('ifnot') operator#{'s' if count > 1}"
      end
      raise RuntimeError # TODO: create error class
    end
  end
end
