require "digest"
require "fileutils"
require "pathname"

module AssetDigest
  class Digester
    attr_accessor :source
    attr_accessor :destination
    attr_accessor :manifest
    attr_accessor :manifest_path
    attr_accessor :algorithm

    def initialize(source:, destination:, manifest_path:, algorithm: Digest::SHA1)
      @source = source
      @destination = destination
      @manifest_path = manifest_path
      @algorithm = algorithm
      @manifest = Manifest.new(source: source, destination: destination)
    end

    def digest_all
      SourcePath.new(source).each_asset do |source_path|
        destination_path = generate_destination_path(source, source_path)
        digest_one(source_path, destination_path)
      end

      write_manifest
      true
    end

    def digest_one(source_path, destination_path)
      ensure_folder_exists(destination_path)
      manifest.add(source_path, destination_path)
      place_content(source_path, destination_path)
    end

    private

    def generate_digest(source)
      digest = algorithm.new

      source.open("rb") do |f|
        until f.eof?
          digest.update(f.read(1024))
        end
      end

      digest.hexdigest.slice(0, 10)
    end

    def generate_destination_path(source, source_path)
      sha = generate_digest(source_path)
      ext = source_path.extname
      filename = source_path.relative_path_from(source).to_s.chomp(ext)

      output = "#{filename}-#{sha}#{ext}"
      Pathname.new(destination).join(output)
    end

    def ensure_folder_exists(destination_path)
      FileUtils.mkdir_p(destination_path.dirname)
    end

    def place_content(source_path, destination_path)
      return if destination_path.exist?

      FileUtils.cp(source_path, destination_path)
    end

    def write_manifest
      manifest.write_file(manifest_path)
    end
  end
end
