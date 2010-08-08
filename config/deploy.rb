set :application, 'StIPS'
set :user, 'p37r5007'
set :domain, 'stips.se'
set :mongrel_port, '17770'
set :server_hostname, 'stips.se'

set :git_account, 'mushfique'

role :web, server_hostname
role :app, server_hostname
role :db, server_hostname, :primary => true

default_run_options[:pty] = true
set :repository,  "git@github.com:ashrafuzzaman/stips.git"
set :scm, "git"
set :user, user

ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false
set :deploy_to, "/home/#{user}/#{application}"
