# -*- encoding : utf-8 -*-

require 'net/http'

desc 'Update vendor files.'
task :vendor_update do
  address  = 's1.ucoz.net'
  filename = '/src/socCom.css'
  css_path = VENDOR_DIR.join('stylesheets', 'ucoz')
  local_file_path = css_path.join('socCom.css')
  current_time = Time.now

  FileUtils.mkpath css_path

  Net::HTTP.start(address) do |http|
    body = http.get(filename).body
    body.chomp!
    LOGGER.info{"Writing file: #{local_file_path}"}
    File.open(local_file_path, 'w') do |f|
      f.puts "/* Original: http://#{address}#{filename} */"
      f.puts "/* Last check: #{current_time} */"
      f.puts
      f.puts body
    end
  end
end
