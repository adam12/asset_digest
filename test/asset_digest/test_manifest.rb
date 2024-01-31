require "test_helper"

module AssetDigest
  class TestManifest < Minitest::Test
    def test_write
      manifest = Manifest.new
      digested_file = DigestedFile.new(relative_source_path: "test.js", relative_destination_path: "test-SHA.js")

      manifest.add(digested_file)

      assert manifest.write(output = StringIO.new)
      assert_equal <<~EXPECTED_MANIFEST.strip, output.string
        {"test.js":"test-SHA.js"}
      EXPECTED_MANIFEST
    end

    def test_write_file
      Tempfile.create do |f|
        manifest = Manifest.new
        digested_file = DigestedFile.new(relative_source_path: "test.js", relative_destination_path: "test-SHA.js")

        manifest.add(digested_file)

        assert manifest.write_file(f.path)
        assert_equal <<~EXPECTED_MANIFEST.strip, f.read
          {"test.js":"test-SHA.js"}
        EXPECTED_MANIFEST
      end
    end
  end
end
