source "https://rubygems.org"

gem "sinatra"
gem "puma"
gem "rackup"
gem "canister"

group :metrics do
  gem "yabeda-puma-plugin"
  gem "yabeda-prometheus"
  gem "prometheus-client",
    require: File.expand_path(File.join("lib", "metrics"), __dir__)
end

group :development, :test do
  gem "debug"
end

group :test do
  gem "rspec"
  gem "rack-test"
  gem "simplecov"
  gem "simplecov-lcov"
end

group :development do
  gem "standard"
  gem "ruby-lsp"
end
