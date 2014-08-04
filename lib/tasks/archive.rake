# -*- encoding : utf-8 -*-

desc 'Make backup archive with templates.'
task :archive do

  files_matching = YAML.load_file('config/files_matching.yml')
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
          if str.size > 99999
            LOGGER.error "Size of #{arch_name} > 99999"
            raise 'Too big template.'
          end
        end
        stream.write str
      end
    end
  end

  LOGGER.info "Created file: #{zipfile_name}"
end
