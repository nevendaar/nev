# -*- encoding : utf-8 -*-

class UcozConditionStatement
  def initialize(erb_out, *conditions, not_flag: false)
    @not_flag = !!not_flag
    @erb_out = erb_out
    @closed = false # tag closed?
    @has_else = false
    condition = conditions.flatten.join(@not_flag ? ' || ' : ' && ')
    @erb_out << "<?if#{'not' if @not_flag}(#{condition})?>"
    yield if block_given?
  end

  def else
    if @has_else
      LOGGER.error "if#{'not' if @not_flag} operator have multiple else blocks!"
      raise RuntimeError # TODO: create error class
    end
    @has_else = true
    LOGGER.warn 'ifnot used with else' if @not_flag
    @erb_out << '<?else?>'
    yield if block_given?
    self
  end

  def endif!
    if @closed
      LOGGER.error "if#{'not' if @not_flag} operator already closed!"
      raise RuntimeError # TODO: create error class
    end
    @closed = true
    @erb_out << '<?endif?>'
    nil
  end

  def closed?
    @closed
  end
end
