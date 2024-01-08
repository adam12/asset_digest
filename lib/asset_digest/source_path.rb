require "pathname"

module AssetDigest
  class SourcePath
    def initialize(source)
      @source = Pathname.new(source)
    end

    def each_asset
      @source.glob("**/*").each do |source|
        next if source.directory?

        yield source
      end
    end
  end
end
