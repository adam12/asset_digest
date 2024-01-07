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
        destination_path = generate_destination_path(source_path)
        ensure_folder_exists(destination_path)
        FileUtils.cp(source_path, destination_path)
      end
    end

    private

    def generate_digest(source)
      Digest::SHA256.hexdigest(source.read)
    end

    def generate_destination_path(source_path)
      sha = generate_digest(source_path)
      ext = source_path.extname
      filename = source_path.basename.to_s.chomp(ext)

      output = "#{filename}-#{sha}#{ext}"
      Pathname.new(destination).join(output)
    end

    def ensure_folder_exists(destination_path)
      FileUtils.mkdir_p(destination_path.dirname)
    end
  end
end
