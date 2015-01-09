# -*- encoding : utf-8 -*-

require_relative 'sinatra/load_from_cache'
require_relative 'sinatra/send_asset'

DOCTYPE = "<!DOCTYPE html>\n"
LINKED_DIRS = %w[img Reklama site].each(&:freeze).freeze

get '/' do
  DOCTYPE + TemplateCompiler.compile('templates/pages/index.html.erb', true)
end

get '/css/app.min.css' do
  send_asset 'build/stylesheets/app.min.css'
end

get '/js/app.min.js' do
  send_asset 'build/javascripts/app.min.js'
end

LINKED_DIRS.each do |l_dir|
  get "/#{l_dir}/*" do |path|
    load_from_cache "/#{l_dir}/#{path}"
  end
end
