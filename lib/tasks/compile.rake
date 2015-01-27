# -*- encoding : utf-8 -*-

require 'digest/sha1'

desc 'Compile assets.'
task :compile do
  logger = LOGGER.dup
  logger.progname = 'Sprockets'

  browsers = YAML.load_file('config/autoprefixer.yml')
  browsers = browsers && browsers['browsers']

  compile_assets = ->(source_dir, bundles) do
    sprockets = Sprockets::Environment.new(ROOT) do |env|
      env.js_compressor  = :uglify
      env.css_compressor = :scss
      env.logger = logger
    end

    AutoprefixerRails.install(sprockets, :browsers => browsers)

    sprockets.append_path(source_dir.join('stylesheets').to_s)
    sprockets.append_path(source_dir.join('javascripts').to_s)
    sprockets.append_path(VENDOR_DIR.join('javascripts').to_s)

    bundles.each do |bundle, out_filename|
      assets = sprockets.find_asset(bundle.to_s)
      prefix = assets.pathname.to_s.split('/')[-2]
      FileUtils.mkpath BUILD_DIR.join(prefix)
      full_path = BUILD_DIR.join(prefix, out_filename)

      assets.write_to(full_path)
      digest = Digest::SHA1.hexdigest(File.read(full_path))

      LOGGER.debug('Compile') { "Digest: #{digest}" }

      File.open(BUILD_DIR.join(prefix, "#{out_filename}.sha1"), 'a+') do |f|
        old_digest = f.read
        if digest == old_digest
          LOGGER.info('Compile') { 'Digest identical!' }
        else
          f.truncate(0)
          f.write(digest)
        end
      end
    end
  end

  LOGGER.info('Compile') { 'Compile main assets...' }
  compile_assets.call(SOURCE_DIR, BUNDLES)

  LOGGER.info('Compile') { 'Compile my.css...' }
  compile_assets.call(SOURCE_DIR, {:'minichat.css' => 'my.min.css'})

  LOGGER.info('Compile') { 'Compile PDA assets...' }
  compile_assets.call(PDA_SOURCE_DIR, PDA_BUNDLES)
end
