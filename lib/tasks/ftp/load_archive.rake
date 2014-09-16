# -*- encoding : utf-8 -*-

require 'net/ftp'

namespace :ftp do
  desc 'Load specific template archive into server.'
  task :load_archive do
    path_to_file = ARGV[1].to_s
    backup_dir = '_tbkp'
    if File.exist?(path_to_file)
      if File.extname(path_to_file) == '.zip' &&
          `file -b --mime-type #{path_to_file}`.chomp == 'application/zip'
        ftp_config = YAML.load_file('config/ftp.yml')['ftp']
        ftp = Net::FTP.new(ftp_config['host'])
        begin
          ftp.passive = true
          ftp.login ftp_config['login'], ftp_config['password']

          unless ftp.list('/').any? { |dir| dir.match(Regexp.new("\s#{backup_dir}$")) }
            ftp.mkdir("/#{backup_dir}")
          end

          filename = File.basename(path_to_file)

          if ftp.list("/#{backup_dir}").any? { |dir| dir.match(Regexp.new("\s#{filename}$")) }
            LOGGER.error('ftp:load_archive') do
              "File: \"#{filename}\" already exists on the server."
            end
          else
            ftp.putbinaryfile(path_to_file, "/#{backup_dir}/#{filename}")
            LOGGER.info('ftp:load_archive') do
              "File: \"#{filename}\" loaded on the server.\n" \
              "Now, you can go to #{AppConfig.config.home_url}/tmpls/?a=backupt"
            end
          end
        ensure
          ftp.close
        end
      else
        LOGGER.error('ftp:load_archive') do
          "File: \"#{ARGV[1]}\" doesn't looks like zip archive."
        end
      end
    else
      LOGGER.error('ftp:load_archive') { "No such file: \"#{ARGV[1]}\"" }
    end
  end
end
