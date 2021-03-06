# -*- encoding : utf-8 -*-

desc 'Generate complete html page example'
task :generate do
  AppConfig.configure do |config|
    config.env = :test
  end
  path = ARGV[1] || 'templates/pages/index.html.erb'
  doctype = "<!DOCTYPE html>\n"
  puts "\n" << doctype << compile_template(path, true)
end

task :g => :generate
