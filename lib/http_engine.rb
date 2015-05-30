# -*- encoding : utf-8 -*-

module HTTPEngine
  def self.with_auth
    uid_config = YAML.load_file('config/auth.yml')['uid']
    login_host = 'login.uid.me'
    target_host = uid_config['host']

    client = Mechanize.new do |a|
      a.log = Logger.new('log/mechanize.log')
      a.user_agent = uid_config['user_agent']
    end

    cookie_defaults = {
        domain: '.uid.me',
        path: '/',
        expires: (Date.today + 1).to_s
    }

    # Initial cookies
    client.cookie_jar << Mechanize::Cookie.new(cookie_defaults.merge(name: 'lng', value: 'ru'))
    client.cookie_jar << Mechanize::Cookie.new(cookie_defaults.merge(name: 'uPriv', value: '0'))
    client.cookie_jar << Mechanize::Cookie.new(cookie_defaults.merge(domain: 'login.uid.me', name: 'UZRef', value: "http://#{target_host}/"))

    login_data = URI.encode_www_form(
        ajax: 0,
        goto: 'url',
        url: "http://#{login_host}/?site=#{uid_config['site_id']}&ref=http%3A%2F%2F#{target_host}%2F",
        email: uid_config['email'],
        pass: uid_config['password'],
        secmode: 0
    )

    # UID login on the site
    client.post("http://#{login_host}/dolog/", login_data)

    begin
      if block_given?
        yield(client, target_host)
      else
        sleep 1
      end
    ensure
      # Logout
      client.get("http://#{target_host}/index/10")
    end
  end
end
