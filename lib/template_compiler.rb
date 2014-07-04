# -*- encoding : utf-8 -*-

require_relative 'helpers/base_helper'
require_relative 'helpers/forum_helper'

class TemplateCompiler

  include BaseHelper
  include ForumHelper

  def self.compile(filename, dont_trim = false)
    LOGGER.debug "Compile file: #{filename}"
    str = trim_utf8_file(filename)
    if File.extname(filename) == '.erb'
      helper = self.new
      str = ERB.new(str, nil, nil, '@_erbout').result(helper.get_binding)
      unclosed_conditions = helper.unclosed_conditions
      if unclosed_conditions > 0
        LOGGER.error "Template have #{unclosed_conditions} unclosed 'if' ('ifnot') operator#{'s' if unclosed_conditions > 1}"
        raise RuntimeError # TODO: create error class
      end
    end
    str.gsub!(/\n\s*\n+/, "\n")
    str.gsub!(/ {2,}/, ' ') unless dont_trim
    str
  end

  def initialize(hash = {})
    @params = hash
    @params[:meta]     = {}
    @params[:vk]       = {}
    @params[:redirect] = {}
    @_erbout = nil
    @cond_operators = []
  end

  def get_binding
    binding
  end

  # template - Symbol (template name) or String (path to file)
  def layout(template = :main)
    if template.instance_of? Symbol
      template = File.read("templates/layouts/#{template}.html.erb").chomp!
    else # template is a path
      template = File.read(template).chomp!
    end
    erbout = @_erbout.dup
    str = ERB.new(template, nil, nil, '@_erbout').result(binding)
    @_erbout = (erbout << str)
  end

  private

  # utf-8 Byte Order Mark
  BOM_TOKEN = "\xEF\xBB\xBF".freeze

  # Trim first 3 bytes from utf-file if needed
  def self.trim_utf8_file(filename)
    str = File.open(filename, 'r') { |f| f.read }
    str.byteslice(0..2) == BOM_TOKEN ? str.byteslice(3..-1) : str
  end
end
