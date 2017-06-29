# config valid only for current version of Capistrano
lock "3.8.2"

set :application, "bazaar_lms"
set :repo_url, "git@github.com:educloudalliance/educloud-demo-lms.git"

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

set :use_sudo, false

# Default value for :pty is false
# Don't change these unless you know what you're doing
set :user,            'deploy'
set :pty,             true
set :puma_threads,    [4, 16]
set :puma_workers,    3
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      # unless `git rev-parse HEAD` == `git rev-parse origin/master`
      #   puts "WARNING: HEAD is not the same as origin/master"
      #   puts "Run `git push` to sync changes."
      #   exit
      # end
    end
  end
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      # before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end
  desc "Tail log files across all hosts"
  task :tail_puma do
    on roles(:all) do
      execute "tail -f #{shared_path}/log/puma.*.log"
    end
  end

  desc "Tail rails log files across all hosts"
  task :tail_rails do
    on roles(:all) do
      execute "tail -f #{shared_path}/log/production.log"
    end
  end

  desc "Tail nginx log files across all hosts"
  task :tail_nginx do
    on roles(:all) do
      execute "tail -f #{shared_path}/log/nginx.*.log"
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
