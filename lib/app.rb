# -*- encoding : utf-8 -*-

require_relative 'sinatra/send_asset'

DOCTYPE = "<!DOCTYPE html>\n"

get '/' do
  DOCTYPE + TemplateCompiler.compile('templates/pages/index.html.erb', true)
end

get '/css/app.min.css' do
  send_asset 'build/stylesheets/app.min.css'
end

get '/js/app.min.js' do
  send_asset 'build/javascripts/app.min.js'
end
