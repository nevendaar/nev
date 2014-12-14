# -*- encoding : utf-8 -*-

require 'net/ftp'

namespace :ftp do
  desc 'Test FTP connection, print files in root directory'
  task :test do
    ftp_config = YAML.load_file('config/ftp.yml')['ftp']
    ftp = Net::FTP.new(ftp_config['host'])
    begin
      ftp.passive = true
      ftp.login ftp_config['login'], ftp_config['password']

      files = ftp.list
      puts files
    ensure
      ftp.close
    end
  end
end
