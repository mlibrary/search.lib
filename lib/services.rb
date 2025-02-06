require "canister"

Services = Canister.new

S = Services

S.register(:app_env) { ENV["APP_ENV"] || "development" }
S.register(:version) { ENV["APP_VERSION"] || `git rev-parse HEAD` }
