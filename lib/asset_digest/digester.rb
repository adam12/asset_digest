require "fileutils"
require "digest"

module AssetDigest
  class Digester
    attr_accessor :destination
    attr_accessor :manifest

    def initialize(destination:, manifest:)
      @destination = destination
      @manifest = manifest
    end

    def digest_all(source)
      Dir.glob("**/*", base: source).each do |file|
        full_path = File.join(source, file)
        sha = Digest::SHA256.hexdigest(File.read(full_path))

        ext = File.extname(file)
        filename = File.basename(file).chomp(ext)

        output = "#{filename}-#{sha}#{ext}"

        FileUtils.cp(full_path, File.join(destination, output))
      end
    end
  end
end
