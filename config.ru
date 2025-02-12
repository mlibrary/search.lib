require "./app"

# use Rack::Deflater
# use Prometheus::Middleware::Collector
use Metrics::Middleware

run Sinatra::Application
