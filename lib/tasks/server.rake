# -*- encoding : utf-8 -*-

desc 'Start simple sinatra application'
task :server do
  AppConfig.configure do |config|
    config.env = :test
  end

  require_relative '../app'

  Sinatra::Application.run!
end
