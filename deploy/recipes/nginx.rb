set_default(:maintenance_path) { "#{shared_path}/system/maintenance.html" }

namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install, roles: :web do
    run "#{sudo} add-apt-repository -y ppa:nginx/stable"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nginx"
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template "nginx_unicorn.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end

  namespace :maintenance do
    desc 'Set maintenance page up'
    task :up, roles: :app do
      set :reason,    (ENV['reason']   || 'manutenção')
      set :deadline,  (ENV['deadline'] || 'em breve')
      template 'maintenance.html.erb', maintenance_path
    end

    desc 'Set maintenance page down'
    task :down, roles: :app do
      run %Q{rm #{maintenance_path}}
    end
  end
end