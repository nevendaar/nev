# -*- encoding : utf-8 -*-

require 'sinatra/base'
require 'net/http'

module Sinatra
  module LoadFromCacheHelper
    def load_from_cache(path)
      cache_dir = '/tmp/nevendaar_cache'
      FileUtils.mkpath cache_dir

      full_path = File.join cache_dir, path

      FileUtils.mkpath File.dirname(full_path)

      unless File.exists?(full_path)
        Net::HTTP.start('nevendaar.com') do |http|
          f = File.open(full_path, 'wb')
          begin
            http.request_get(path) do |resp|
              resp.read_body do |segment|
                f.write(segment)
              end
            end
          ensure
            f.close
          end
        end
      end

      send_file full_path
    end
  end

  helpers LoadFromCacheHelper
end
