require "test_helper"
require "pathname"

module AssetDigest
  class TestManifest < Minitest::Test
    def test_write
      source = Pathname.new("source")
      destination = Pathname.new("destination")
      manifest = Manifest.new(source: source, destination: destination)
      manifest.add(source / "test.js", destination / "test-SHA.js")

      assert manifest.write(output = StringIO.new)

      assert_equal <<~EXPECTED_MANIFEST.strip, output.string
        {"test.js":"test-SHA.js"}
      EXPECTED_MANIFEST
    end

    def test_write_file
      Tempfile.create do |f|
        source = Pathname.new("source")
        destination = Pathname.new("destination")
        manifest = Manifest.new(source: source, destination: destination)
        manifest.add(source / "test.js", destination / "test-SHA.js")

        assert manifest.write_file(f.path)
        assert_equal <<~EXPECTED_MANIFEST.strip, f.read
          {"test.js":"test-SHA.js"}
        EXPECTED_MANIFEST
      end
    end
  end
end
