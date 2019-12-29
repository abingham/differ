$stdout.sync = true
$stderr.sync = true

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
end

require_relative 'src/externals'
require_relative 'src/differ'
require_relative 'src/rack_dispatcher'
externals = Externals.new
differ = Differ.new(externals)
require 'rack'
dispatcher = RackDispatcher.new(differ, Rack::Request)
run dispatcher
