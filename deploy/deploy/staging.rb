set :rails_env, 'staging'
set :server_name, 'dev.pipples.com'
server server_name, :web, :app, :db, primary: true
set :branch, 'develop'