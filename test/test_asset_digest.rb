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
      source: source,
      destination: destination,
      manifest_path: File.join(destination, "manifest.json")
    )

    assert digester.digest_all
    assert File.exist?(destination + "/app-52f25376e8.css")
    expected_manifest = {
      "app.css" => "app-52f25376e8.css",
      "css/styles.css" => "css/styles-af23893a93.css"
    }
    assert_equal expected_manifest, digester.manifest.to_h
  end
end
