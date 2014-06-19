# -*- encoding : utf-8 -*-

require_relative 'helpers/base_helper'
require_relative 'helpers/forum_helper'

class Helper

  include BaseHelper
  include ForumHelper

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

  def layout(template = :main)
    template = File.read("templates/layouts/#{template}.html.erb").chomp!
    erbout = @_erbout.dup
    str = ERB.new(template, nil, nil, '@_erbout').result(binding)
    @_erbout = (erbout << str)
  end
end
