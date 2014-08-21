# -*- encoding : utf-8 -*-

desc 'Compile assets.'
task :compile do
  logger = LOGGER.dup
  logger.progname = 'Sprockets'

  sprockets = Sprockets::Environment.new(ROOT) do |env|
    env.js_compressor  = :uglify
    env.css_compressor = :scss
    env.logger = logger
  end

  sprockets.append_path(SOURCE_DIR.join('stylesheets').to_s)
  sprockets.append_path(SOURCE_DIR.join('javascripts').to_s)
  sprockets.append_path(VENDOR_DIR.join('javascripts').to_s)

  BUNDLES.each do |bundle, out_filename|
    assets = sprockets.find_asset(bundle.to_s)
    prefix = assets.pathname.to_s.split('/')[-2]
    FileUtils.mkpath BUILD_DIR.join(prefix)

    assets.write_to(BUILD_DIR.join(prefix, out_filename))
  end
end
