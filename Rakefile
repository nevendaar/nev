# -*- encoding : utf-8 -*-

#require 'tempfile'
require 'zip'

desc 'Make backup archive with templates.'
task :archive do

  files_matching = {
      'templates/board/main.html'           => 'bd1.t',
      'templates/board/index_section.html'  => 'bd2.t',
      'templates/board/index_category.html' => 'bd3.t',
      'templates/board/show.html'           => 'bd4.t',
      'templates/board/search.html'         => 'bd5.t',
      'templates/board/new_or_edit.html'    => 'bd6.t',
      'templates/board/_material.html'      => 'bd7.t'
  }

  zipfile_name = Time.now.to_i.to_s << '.zip'

  Zip::File.open(zipfile_name, Zip::File::CREATE) do |ar|
    files_matching.each do |arch_name, filename|
      ar.add(filename, arch_name)
    end
  end

  puts "Created file #{zipfile_name}"

end
