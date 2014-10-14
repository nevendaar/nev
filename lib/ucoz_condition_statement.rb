# -*- encoding : utf-8 -*-

class UcozConditionStatement
  PROG_NAME = 'ucoz_if_code'.freeze

  def initialize(erb_out, *conditions, not_flag: false)
    @not_flag = !!not_flag
    @erb_out = erb_out
    @closed = false # tag closed?
    @has_else = false
    @if_content = ''
    @can_simplify = false
    conditions = conditions.flatten
    condition = conditions.join(@not_flag ? ' || ' : ' && ')
    @statement = "<?if#{'not' if @not_flag}(#{condition})?>"
    @erb_out << @statement
    if block_given?
      block_code = yield(@erb_out).to_s
      if conditions.size == 1
        start_index = block_code.rindex(@statement)
        if start_index
          start_index += @statement.size
          @if_content = block_code[start_index..-1].strip
          @can_simplify = @if_content.empty? || @if_content == condition
        end
      end
    end
  end

  def else
    if @has_else
      LOGGER.error(PROG_NAME) do
        "if#{'not' if @not_flag} operator have multiple else blocks!"
      end
      raise RuntimeError # TODO: create error class
    end
    @has_else = true
    LOGGER.warn(PROG_NAME) { 'ifnot used with else' } if @not_flag
    @erb_out << '<?else?>'
    yield(@erb_out) if block_given?
    self
  end

  def endif!
    if @closed
      LOGGER.error(PROG_NAME) do
        "if#{'not' if @not_flag} operator already closed!"
      end
      raise RuntimeError # TODO: create error class
    end
    if !@has_else && @can_simplify
      LOGGER.warn(PROG_NAME) do
        "Maybe expression can be simplified:\n"\
        "`#{@statement}#{@if_content}<?endif?>`"\
        " not the same as: `#{@if_content}`?"
      end
    end
    @closed = true
    @erb_out << '<?endif?>'
  end

  def closed?
    @closed
  end
end
