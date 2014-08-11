# -*- encoding : utf-8 -*-

task :generate do
  AppConfig.configure do |config|
    config.env = :test
  end
  path = ARGV[1] || 'templates/pages/index.html.erb'
  doctype = "<!DOCTYPE html>\n"
  puts doctype << compile_template(path, true)
end

task :g => :generate
