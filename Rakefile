# -*- encoding : utf-8 -*-

require 'rubygems'
require 'bundler'
require 'erb'
require 'yaml'
require 'pathname'
require 'logger'

require 'zip'
require_relative 'helper'

Bundler.require

ROOT       = Pathname(File.dirname(__FILE__))
LOGGER     = Logger.new(STDOUT)
BUNDLES    = %w( app.css app.js )
BUILD_DIR  = ROOT.join('build')
SOURCE_DIR = ROOT.join('files')

# utf-8 Byte Order Mark
BOM_TOKEN = "\xEF\xBB\xBF".freeze

desc 'Compile assets.'
task :compile do
  sprockets = Sprockets::Environment.new(ROOT) do |env|
    #env.js_compressor  = :uglify
    #env.css_compressor = :scss
    env.logger = LOGGER
  end

  sprockets.append_path(SOURCE_DIR.join('css').to_s)
  sprockets.append_path(SOURCE_DIR.join('js').to_s)

  BUNDLES.each do |bundle|
    assets = sprockets.find_asset(bundle)
    prefix, basename = assets.pathname.to_s.split('/')[-2..-1]
    FileUtils.mkpath BUILD_DIR.join(prefix)

    assets.write_to(BUILD_DIR.join(prefix, basename))
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
          str << compile_template(filename)
        end
        stream.write str
      end
    end
  end

  LOGGER.info "Created file #{zipfile_name}"
end

task :test do
  path = ARGV[1] || 'templates/pages/index.html.erb'
  puts compile_template(path, true)
end

# Trim first 3 bytes from utf-file if needed
def trim_utf8_file(filename)
  str = File.open(filename, 'r') { |f| f.read }
  str.byteslice(0..2) == BOM_TOKEN ? str.byteslice(3..-1) : str
end

def compile_template(filename, dont_trim = false)
  str = trim_utf8_file(filename)
  if File.extname(filename) == '.erb'
    str = ERB.new(str, nil, nil, '@_erbout').result(Helper.new.get_binding)
  end
  str.gsub!(/\n\s*\n+/, "\n")
  dont_trim ? str : str.gsub!(/ {2,}/, ' ')
end
