# workers Integer(ENV['WEB_WORKERS'] || 2)
# threads_count = Integer(ENV['WEB_THREADS'] || 5)
# threads threads_count, threads_count

# preload_app!

# rackup DefaultRackup
# port ENV['PORT'] || 3000
# environment ENV['RACK_ENV'] || 'development'

workers ENV.fetch('WEB_CONCURRENCY', 2).to_i
port ENV.fetch('PORT', 3000)
