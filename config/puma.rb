Bundler.require(:metrics)
Metrics.load_config
Metrics.configure_puma(self)
