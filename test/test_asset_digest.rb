# frozen_string_literal: true

require "test_helper"

class TestAssetDigest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AssetDigest::VERSION
  end

  def test_performing_digest
    Dir.mktmpdir do |destination|
      digester = AssetDigest::Digester.new(
        destination: destination,
        manifest_path: File.join(destination, "manifest.json")
      )
      digester.add_source(File.join(__dir__, "support/assets"))
      digester.add_source(File.join(__dir__, "support/assets-other"))

      assert digester.digest_all
      assert File.exist?(destination + "/app-b7ca7577aa.css")
      expected_manifest = {
        "app.css" => "app-b7ca7577aa.css",
        "css/styles.css" => "css/styles-477e369aa7.css",
        "js/app.js" => "js/app-da39a3ee5e.js",
        "css/other-2.css" => "css/other-2-d98a366516.css",
        "other.css" => "other-ec5d074194.css"
      }
      assert_equal expected_manifest, digester.manifest.to_h

      manifest_io = StringIO.new
      digester.manifest.write(manifest_io)

      refute_nil manifest_io.string
    end
  end
end
