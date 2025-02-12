require "canister"

Services = Canister.new

S = Services

S.register(:app_env) { ENV["APP_ENV"] || "development" }
S.register(:version) { ENV["APP_VERSION"] || `git rev-parse HEAD` }
S.register(:project_root) do
  File.absolute_path(File.join(__dir__, ".."))
end
S.register(:config_path) do
  File.join(S.project_root, "config")
end
