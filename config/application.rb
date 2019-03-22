require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'react-rails'
require './app/lib/webpacker_split_chunks_manifest_container'

module ReactRailsSsrSplitchunksExample
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.react.server_renderer_options = {
      # The default is "server_rendering.js" (with extension), but when Webpacker
      # has SplitChunks enabled, it needs the entry name to find the asset and
      # associated chunks.
      files: ['server_rendering']
    }

    # There is a bug with the existing asset container where it calls `Webpacker.manifest.lookup`
    # instead of `Webpacker.manifest.lookup_pack_with_chunks` when SplitChunks is enabled.
    # To fix this, we provide our own asset container.
    React::ServerRendering::BundleRenderer.asset_container_class = WebpackerSplitChunksManifestContainer

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
