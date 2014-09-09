# -*- encoding : utf-8 -*-

require 'net/http'
require 'yaml'

desc 'Update vendor files.'
task :vendor_update do
  comment = ->(str, type) do
    case type
      when 'javascripts'
        "// #{str}"
      when 'stylesheets'
        "/* #{str} */"
      else
        ''
    end
  end

  vendors_hash = YAML.load_file('config/vendor_files.yml')

  vendors_hash.each do |vendor_name, val|
    address = val.delete('hostname')

    Net::HTTP.start(address) do |http|
      val.each do |asset_type, files|
        # Ex: vendor_name = 'ucoz', asset_type = 'javascripts'
        asset_path = VENDOR_DIR.join(asset_type, vendor_name)
        FileUtils.mkpath asset_path

        files.each do |url, filename|
          local_file_path = asset_path.join(filename)
          LOGGER.debug('Net::HTTP') { "GET #{address}#{url}" }
          body = http.get(url).body
          current_time = Time.now
          body.gsub!(/[ \t]+\n/, "\n")
          body.chomp!
          LOGGER.info('Vendor update') { "Writing file: #{local_file_path}" }
          File.open(local_file_path, 'w') do |f|
            f.puts comment.call("Original: http://#{address}#{url}", asset_type)
            f.puts comment.call("Last check: #{current_time}", asset_type)
            f.puts
            f.puts body
          end
        end
      end
    end
  end
end
