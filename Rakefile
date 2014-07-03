# -*- encoding : utf-8 -*-

require 'rubygems'
require 'bundler'
require 'erb'
require 'yaml'
require 'pathname'
require 'logger'

require_relative 'lib/template_compiler'

Bundler.require

require 'rspec/core/rake_task'

ROOT       = Pathname(File.dirname(__FILE__))
LOGGER     = Logger.new(STDERR)
BUNDLES    = {
    :'app.css' => 'app.min.css',
    :'app.js'  => 'app.min.js'
}
BUILD_DIR  = ROOT.join('build')
SOURCE_DIR = ROOT.join('assets')
VENDOR_DIR = ROOT.join('vendor', 'assets')

desc 'Compile assets.'
task :compile do
  sprockets = Sprockets::Environment.new(ROOT) do |env|
    env.js_compressor  = :uglify
    env.css_compressor = :scss
    env.logger = LOGGER
  end

  sprockets.append_path(SOURCE_DIR.join('stylesheets').to_s)
  sprockets.append_path(SOURCE_DIR.join('javascripts').to_s)
  sprockets.append_path(VENDOR_DIR.join('javascripts').to_s)

  BUNDLES.each do |bundle, out_filename|
    assets = sprockets.find_asset(bundle.to_s)
    prefix = assets.pathname.to_s.split('/')[-2]
    FileUtils.mkpath BUILD_DIR.join(prefix)

    assets.write_to(BUILD_DIR.join(prefix, out_filename))
  end
end

desc 'Make backup archive with templates.'
task :archive do

  files_matching = YAML.load_file('files_matching.yml')
  zipfile_name   = Time.now.to_i.to_s << '.zip'

  Zip.setup do |config|
    config.sort_entries = true
  end

  Zip::File.open(zipfile_name, Zip::File::CREATE) do |ar|
    files_matching.each do |arch_name, filename|
      ar.get_output_stream(arch_name) do |stream|
        str = ''
        if filename.kind_of? Array
          raise 'Incorrect array in files_matching.yml' if filename.size != 2
          f1 = compile_template(filename[0])
          f2 = compile_template(filename[1])
          str << ('%05d' % f1.size) << (' ' * 5) << f1 << f2
          LOGGER.warn "Size of #{arch_name} > 99999: this situation is not tested yet." if (f1.size + f2.size) > 99999
        else
          str << compile_template(filename).to_s
        end
        stream.write str
      end
    end
  end

  LOGGER.info "Created file #{zipfile_name}"
end

task :show do
  path = ARGV[1] || 'templates/pages/index.html.erb'
  puts compile_template(path, true)
end

RSpec::Core::RakeTask.new
task :test => :spec
task :default => :spec

def compile_template(filename, dont_trim = false)
  unless File.exists?(filename)
    LOGGER.warn "Cannot find file: #{filename}\nSkipping..."
    return ''
  end
  TemplateCompiler.compile(filename, dont_trim)
end
