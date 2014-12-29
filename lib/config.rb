# -*- encoding : utf-8 -*-

require 'yaml'

module AppConfig
  class << self
    attr_accessor :config
  end

  # Configures global settings for our application
  # AppConfig.configure do |config|
  #   config.home_url = 'http://example.com'
  # end
  def self.configure
    yield @config ||= self::Configuration.new
  end

  class Configuration #:nodoc:
    attr_accessor :env,
                  :deprecated_codes,
                  :css_version,
                  :js_version,
                  :home_url,
                  :ucoz_url

    def initialize
      @env      = :development
      @deprecated_codes = YAML.load_file('config/deprecated_codes.yml')
      @home_url = 'http://0.0.0.0'
      @ucoz_url = @home_url
      @css_version = 1
      @js_version  = 1
    end
  end
end
