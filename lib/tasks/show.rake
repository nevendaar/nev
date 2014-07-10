# -*- encoding : utf-8 -*-

task :show do
  path = ARGV[1] || 'templates/pages/index.html.erb'
  puts compile_template(path, true)
end
