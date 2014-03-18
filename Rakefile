# -*- encoding : utf-8 -*-

require 'yaml'
require 'zip'

desc 'Make backup archive with templates.'
task :archive do

  files_matching = YAML.load_file('files_matching.yml')

  zipfile_name = Time.now.to_i.to_s << '.zip'

  Zip::File.open(zipfile_name, Zip::File::CREATE) do |ar|
    files_matching.each do |arch_name, filename|
      ar.add(filename, arch_name)
    end
  end

  puts "Created file #{zipfile_name}"

end
