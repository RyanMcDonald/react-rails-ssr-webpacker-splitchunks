class WebpackerSplitChunksManifestContainer < React::ServerRendering::WebpackerManifestContainer
  def find_asset(logical_path)
    asset_paths = manifest.lookup_pack_with_chunks(logical_path, type: :javascript)

    asset_contents = begin
      if Webpacker.dev_server.running?
        ds = Webpacker.dev_server
        asset_paths.map do |asset_path|
          # Remove the protocol and host from the asset path. Sometimes webpacker includes this, sometimes it does not
          asset_path.slice!("#{ds.protocol}://#{ds.host_with_port}")
          dev_server_asset = open("#{ds.protocol}://#{ds.host_with_port}#{asset_path}").read
          dev_server_asset.sub!(CLIENT_REQUIRE, '//\0')
          dev_server_asset
        end
      else
        asset_paths.map do |asset_path|
          full_path = ::Rails.root.join('public', asset_path[1..-1])
          File.read(full_path)
        end
      end
    end

    asset_contents.join("\n")
  end
end
