# frozen_string_literal: true

require_relative "asset_digest/version"

module AssetDigest
  class Error < StandardError; end

  autoload :Digester, __dir__ + "/asset_digest/digester"
end
