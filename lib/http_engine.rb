# -*- encoding : utf-8 -*-

module HTTPEngine
  def self.with_auth
    uid_config = YAML.load_file('config/auth.yml')['uid']
    login_host = 'login.uid.me'
    target_host = uid_config['host']

    client = HTTPClient.new(agent_name: uid_config['user_agent'])
    # Initial cookie is readonly, don't rewrite it!
    client.set_cookie_store('config/initial_cookie.tsv')

    login_data = URI.encode_www_form(
        ajax: 0,
        goto: 'url',
        url: "http://#{login_host}/?site=#{uid_config['site_id']}&ref=http%3A%2F%2F#{target_host}%2F",
        email: uid_config['email'],
        pass: uid_config['password'],
        secmode: 0
    )

    client.debug_dev = nil #$stderr

    # UID login
    result = client.post("http://#{login_host}/dolog/", login_data)
    location_with_key = result.header['location'].first

    # Подменяем домен для куки, чтобы отправить её в следующем запросе
    bad_cookie = client.cookies.detect { |c| c.name == 'uNet' }
    bad_cookie.domain = '.uid.me'
    bad_cookie.domain_orig = '.uid.me'
    # Заменяем старую куку новой
    client.cookie_manager.add bad_cookie

    # Site login
    client.get(location_with_key, follow_redirect: true)

    if block_given?
      yield(client, target_host)
    else
      sleep 1
    end

    # Logout
    client.get("http://#{target_host}/index/10", follow_redirect: true)

    client.debug_dev = nil
  end
end
