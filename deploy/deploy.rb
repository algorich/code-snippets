require 'bundler/capistrano'
require 'capistrano/ext/multistage'

load 'config/recipes/base'
load 'config/recipes/nginx'
load 'config/recipes/unicorn'
# Choose a database
# load 'config/recipes/mysql'
# load 'config/recipes/postgresql'
load 'config/recipes/nodejs'
load 'config/recipes/rbenv'
load 'config/recipes/check'
load 'config/recipes/delayed_job'
load 'config/recipes/monit'
load 'config/recipes/ufw'
load 'config/recipes/fail2ban'
load 'config/recipes/project_dependencies'
load 'config/recipes/info' # this should be the last recipe to be loaded

set :stages, %w(production staging)

set :application, 'pipples'
set :user, 'deploy'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository, "git@gitlab.com:algorich/#{application}.git"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :project_name, 'Pipples'

after 'deploy', 'deploy:cleanup' # keep only the last 5 releases