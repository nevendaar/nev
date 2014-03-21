# -*- encoding : utf-8 -*-

require 'yaml'
require 'zip'

desc 'Make backup archive with templates.'
task :archive do

  files_matching = YAML.load_file('files_matching.yml')
  zipfile_name   = Time.now.to_i.to_s << '.zip'
  bom_token      = [0xef, 0xbb, 0xbf]                   # Byte Order Mark

  Zip.setup do |config|
    config.sort_entries = true
  end

  Zip::File.open(zipfile_name, Zip::File::CREATE) do |ar|
    files_matching.each do |filename, arch_name|
      ar.get_output_stream(arch_name) do |stream|
        bytes = Array.new
        File.open(filename, 'r') { |f| bytes = f.read.bytes }
        bytes.shift(3) if bytes[0..2] == bom_token
        stream.write bytes.pack('c*')
      end
    end
  end

  puts "Created file #{zipfile_name}"

end
