require "pathname"
require "json"

module AssetDigest
  class Manifest
    def initialize
      @manifest = {}
    end

    def add(digested_file)
      @manifest[digested_file.relative_source_path.to_s] = digested_file.relative_destination_path.to_s
      true
    end

    def to_h
      @manifest
    end

    def write(destination)
      destination.write(@manifest.to_json)
    end

    def write_file(path)
      File.open(path, "w") do |f|
        write(f)
      end
    end
  end
end
