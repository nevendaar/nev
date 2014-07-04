# -*- encoding : utf-8 -*-

require 'tempfile'
require 'logger'

require_relative '../lib/template_compiler'

LOGGER = Logger.new('/dev/null') # TODO: move into config!
