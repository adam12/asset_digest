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
      manifest_path: File.join(destination, "manifest.json")
    )

    assert digester.digest_all(source)
    assert File.exist?(destination + "/app-52f25376e82c23e5cf88b53cdb568c30cb3fe1432de08134d8280bbc43c91f16.css")
    expected_manifest = {
      "app.css" => "app-52f25376e82c23e5cf88b53cdb568c30cb3fe1432de08134d8280bbc43c91f16.css",
      "css/styles.css" => "css/styles-af23893a93ba32da145b8de8c91f434f6b6e308d9756ae6f29c5382498aea672.css"
    }
    assert_equal expected_manifest, digester.manifest.to_h
  end
end
