# frozen_string_literal: true

require_relative "asset_digest/version"

module AssetDigest
  class Error < StandardError; end

  autoload :Digester, __dir__ + "/asset_digest/digester"
  autoload :Manifest, __dir__ + "/asset_digest/manifest"
  autoload :SourcePath, __dir__ + "/asset_digest/source_path"
end
