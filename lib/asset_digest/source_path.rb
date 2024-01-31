require "pathname"

module AssetDigest
  Source = Data.define(:path, :relative_path) do
    def open(...)
      path.open(...)
    end

    def extname(...)
      path.extname(...)
    end

    def relative_path_from(...)
      path.relative_path_from(...)
    end

    def to_s
      path.to_s
    end
    alias_method :to_str, :to_s
  end

  class SourcePath
    def initialize(source)
      @source = Pathname.new(source)
    end

    def each_asset
      @source.glob("**/*").each do |source|
        next if source.directory?

        yield Source.new(
          path: source,
          relative_path: source.relative_path_from(@source)
        )
      end
    end
  end
end
