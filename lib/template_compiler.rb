# -*- encoding : utf-8 -*-

require_relative 'helpers/base_helper'
require_relative 'helpers/ucoz_helper'
require_relative 'helpers/forum_helper'

class TemplateCompiler

  include BaseHelper
  include UcozHelper
  include ForumHelper

  def self.compile(filename, dont_trim = false)
    LOGGER.debug "Compile file: #{filename}"
    str = trim_utf8_file(filename)
    if File.extname(filename) == '.erb'
      helper = self.new
      str = ERB.new(str, nil, nil, '@_erbout').result(helper.get_binding)
      helper.check_conditions!
    end
    str.gsub!(/\n\s*\n+/, "\n")
    str.gsub!(/ {2,}/, ' ') unless dont_trim
    str
  end

  def initialize(hash = {})
    @params = hash
    @params[:meta]     ||= {}
    @params[:vk]       ||= {}
    @params[:redirect] ||= {}
    @_erbout = nil
    @cond_operators = []
    @locals = {} # For partials
  end

  def get_binding
    binding
  end

  # template - Symbol (partial name) or String (path to file)
  def render(partial, locals: {})
    path = partial
    path = "templates/layouts/partials/_#{partial}.html.erb" if partial.instance_of? Symbol
    template = File.read(path).chomp!

    helper = self.class.new(Marshal.load(Marshal.dump(@params)))
    helper.instance_variable_set(:@locals, locals)

    last_line = @_erbout.split("\n").last
    indent_level = last_line ? last_line[/\A */].size : 0

    str = ERB.new(template, nil, nil, '@_erbout').result(helper.get_binding)
    helper.check_conditions!

    str.gsub!("\n", "\n#{' ' * indent_level}")
    str
  end

  # template - Symbol (template name) or String (path to file)
  def layout(template = :main)
    path = template
    path = "templates/layouts/#{template}.html.erb" if template.instance_of? Symbol
    template = File.read(path).chomp!
    erbout = @_erbout.dup
    str = ERB.new(template, nil, nil, '@_erbout').result(binding)
    @_erbout = (erbout << str)
  end

  private

  # utf-8 Byte Order Mark
  BOM_TOKEN = "\xEF\xBB\xBF".freeze

  # Trim first 3 bytes from utf-file if needed
  def self.trim_utf8_file(filename)
    str = File.read(filename)
    str.byteslice(0..2) == BOM_TOKEN ? str.byteslice(3..-1) : str
  end
end
