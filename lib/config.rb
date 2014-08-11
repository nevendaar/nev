# -*- encoding : utf-8 -*-

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
                  :home_url

    def initialize
      @env      = :development
      @home_url = 'http://0.0.0.0'
    end
  end
end
