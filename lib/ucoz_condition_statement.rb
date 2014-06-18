# -*- encoding : utf-8 -*-

class UcozConditionStatement
  def initialize(condition, erb_out, not_flag = nil)
    @erb_out = erb_out
    @erb_out << "<?if#{'not' if not_flag}(#{condition.to_s})?>\n"
  end

  def else
    @erb_out << "<?else?>\n"
    yield if block_given?
    self
  end

  def endif!
    @erb_out << "<?endif?>\n"
  end
end
