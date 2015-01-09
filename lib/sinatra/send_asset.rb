# -*- encoding : utf-8 -*-

require 'sinatra/base'

module Sinatra
  module SendAssetHelper
    def send_asset(path)
      if File.exists?(path)
        send_file path
      else
        LOGGER.warn("File: #{path} not exist!")
        status 404
        body ''
      end
    end
  end

  helpers SendAssetHelper
end
