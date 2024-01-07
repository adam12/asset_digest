# frozen_string_literal: true

require "test_helper"

class TestAssetDigest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AssetDigest::VERSION
  end

  def test_performing_digest
    destination = Dir.mktmpdir
    source = File.join(__dir__, "support/assets")
    digester = AssetDigest::Digester.new(
      destination: destination,
      manifest: File.join(destination, "manifest.json")
    )

    assert digester.digest_all(source)
    assert File.exist?(destination + "/app-52f25376e82c23e5cf88b53cdb568c30cb3fe1432de08134d8280bbc43c91f16.css")
  end
end
