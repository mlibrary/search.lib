require "./app"
require "yabeda/prometheus"
require "prometheus/middleware/collector"

# use Rack::Deflater
use Prometheus::Middleware::Collector
use Yabeda::Prometheus::Exporter, port: 9394

run Sinatra::Application
