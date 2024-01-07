require "digest"
require "fileutils"
require "pathname"

module AssetDigest
  class Digester
    attr_accessor :destination
    attr_accessor :manifest

    def initialize(destination:, manifest:)
      @destination = destination
      @manifest = manifest
    end

    def digest_all(source)
      Pathname.new(source).glob("**/*").each do |source_path|
        sha = Digest::SHA256.hexdigest(source_path.read)

        ext = source_path.extname
        filename = source_path.basename.to_s.chomp(ext)

        output = "#{filename}-#{sha}#{ext}"
        destination_path = Pathname.new(destination).join(output)

        FileUtils.cp(source_path, destination_path)
      end
    end
  end
end
