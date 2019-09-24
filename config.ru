$stdout.sync = true
$stderr.sync = true

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
end

require_relative 'src/differ'
require_relative 'src/externals'
require_relative 'src/rack_dispatcher'
require 'rack'
use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }
externals = Externals.new
differ = Differ.new(externals)
dispatcher = RackDispatcher.new(differ, Rack::Request)
options = { Port:4567 }
Rack::Handler::Thin.run(dispatcher,options) do |server|
  server.threaded = true
end
