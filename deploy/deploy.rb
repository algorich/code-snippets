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
load 'config/recipes/info' # this should be the last recipe to be loaded

set :stages, %w(production staging)
set :default_stage, 'staging'

# Depend of stage
# set :rails_env, 'staging'
# server 'dev.pipples.com', :web, :app, :db, primary: true

set :application, 'pipples'
set :user, 'deploy'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository, "git@gitlab.com:algorich/#{application}.git"
# Depend of stage
# set :branch, 'develop'

set :maintenance_template_path, File.expand_path('../recipes/templates/maintenance.html.erb', __FILE__)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy', 'deploy:cleanup' # keep only the last 5 releases