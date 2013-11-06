def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc 'Install everything into the server'
  task :install do
    run "#{sudo} apt-get -y install git-core python-software-properties vim htop"
  end

  desc 'Run database migrations'
  task :migrate do
    run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} db:migrate}
  end
  after 'postgresql:symlink', 'deploy:migrate'
end
