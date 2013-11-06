require 'delayed/recipes'

set_default(:delayed_job_pid_file) { "#{current_path}/tmp/pids/delayed_job.pid" }
set_default(:delayed_job_command) { 'bin/delayed_job' }

# http://migre.me/gyN2k
set_default(:delayed_job_full_command) { "/bin/su - deploy -c 'cd #{current_path}; RAILS_ENV=#{rails_env} #{delayed_job_command}'" }

after 'deploy:stop',    'delayed_job:stop'
after 'deploy:start',   'delayed_job:start'
after 'deploy:restart', 'delayed_job:restart'

# If you want to use command line options, for example to start multiple
# workers, define a Capistrano variable delayed_job_args:
#
#   set :delayed_job_args, '-n 2'