# -*- encoding : utf-8 -*-

namespace :auth do
  desc 'Update specified template(s) in the site with auth'
  task :update_template do
    HTTPEngine.with_auth do |agent, host|
      args = ARGV.drop(1)
      args.each do |template_path|
        template = compile_template(template_path)
        LOGGER.info "Updating: #{template_path}"
        if template_path.start_with?('pages/index/')
          template_id = /(?<id>\d+)/.match(template_path)[:id]
          page = agent.get("http://#{host}/index/31-#{template_id}-0-1-2")
          form = page.form('addform')
          form.message = template
          agent.submit(form)
          sleep 1
        else
          LOGGER.error "Unsupported file: #{template_path}"
        end
      end
    end
  end
end
