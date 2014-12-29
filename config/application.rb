# -*- encoding : utf-8 -*-

require_relative '../lib/config'

AppConfig.configure do |config|
  config.home_url = 'http://nevendaar.com'
  config.ucoz_url = 'http://nevendaar.3dn.ru'
  js_digest_path  = 'build/javascripts/app.min.js.sha1'
  css_digest_path = 'build/stylesheets/app.min.css.sha1'
  config.js_version  = File.read(js_digest_path)[0..8]  if File.exist?(js_digest_path)
  config.css_version = File.read(css_digest_path)[0..8] if File.exist?(css_digest_path)
end
