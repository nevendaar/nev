# -*- encoding : utf-8 -*-

require 'rubygems'
require 'bundler'
require 'erb'
require 'yaml'
require 'pathname'

require_relative 'lib/http_engine'
require_relative 'lib/log_formatter'
require_relative 'lib/template_compiler'

Bundler.require

require 'rspec/core/rake_task'

ROOT       = Pathname(File.dirname(__FILE__))
LOGGER     = Logger.new(STDERR)
LOGGER.formatter = LogFormatter.new

BUNDLES    = {
    :'app.css' => 'app.min.css',
    :'app.js'  => 'app.min.js'
}.each { |k, v| v.freeze }.freeze
PDA_BUNDLES = {
    :'app.css' => 'app_pda.min.css',
    :'app.js'  => 'app_pda.min.js'
}.each { |k, v| v.freeze }.freeze

BUILD_DIR  = ROOT.join('build')
SOURCE_DIR = ROOT.join('assets')
VENDOR_DIR = ROOT.join('vendor', 'assets')
PDA_SOURCE_DIR = ROOT.join('assets_pda')

RSpec::Core::RakeTask.new
task :test => :spec
task :default => :spec

def compile_template(filename, dont_trim = false)
  unless File.exist?(filename)
    LOGGER.warn('rake') { "Cannot find file: #{filename}\nSkipping..." }
    return ''
  end
  TemplateCompiler.compile(filename, dont_trim)
end

Dir.glob('lib/tasks/**/*.rake').each { |task| load task }
