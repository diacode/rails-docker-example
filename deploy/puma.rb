workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 1)
threads threads_count, threads_count

rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

bind "unix:///tmp/puma.sock"