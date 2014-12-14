# -*- encoding : utf-8 -*-

require 'net/ftp'

namespace :ftp do
  desc 'Load assets from ./build/ into server.'
  task :load_assets do

    css_file_path = 'build/stylesheets/app.min.css'
    js_file_path  = 'build/javascripts/app.min.js'

    css_dir = 'css'
    js_dir  = 'js'

    replace_file = ->(ftp, file_path, dir_path) do
      if File.exists?(file_path)
        filename = File.basename(file_path)
        unless ftp.list('/').any? { |dir| dir.match(Regexp.new("\s#{dir_path}$")) }
          LOGGER.debug('ftp:load_assets') { "MKDIR /#{dir_path}" }
          ftp.mkdir("/#{dir_path}")
        end
        if ftp.list("/#{dir_path}").any? { |dir| dir.match(Regexp.new("\s#{filename}$")) }
          LOGGER.debug('ftp:load_assets') do
            "Delete old: \"/#{dir_path}/#{filename}\""
          end
          ftp.delete "/#{dir_path}/#{filename}"
        end
        ftp.putbinaryfile(file_path, "/#{dir_path}/#{filename}")
        LOGGER.info('ftp:load_assets') do
          "File: \"#{file_path}\" loaded to the \"/#{dir_path}/#{filename}\"."
        end
      else
        LOGGER.warn('ftp:load_assets') do
          "File: \"#{file_path}\" not found.\nSkipping..."
        end
      end
    end

    if Dir.exists?('build')
      ftp_config = YAML.load_file('config/ftp.yml')['ftp']
      ftp = Net::FTP.open(ftp_config['host'])
      begin
        ftp.passive = true
        ftp.login ftp_config['login'], ftp_config['password']

        replace_file.call(ftp, css_file_path, css_dir)
        replace_file.call(ftp, js_file_path,  js_dir)
      ensure
        ftp.close
      end
    else
      LOGGER.error('ftp:load_assets') do
        'Directory "build" not found: run `rake compile` first'
      end
    end
  end
end
