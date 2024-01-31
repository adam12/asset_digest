# frozen-string-literal: true

require "pathname"

module AssetDigest
  class DigestedFile
    attr_accessor :relative_source_path
    attr_accessor :relative_destination_path

    def initialize(relative_source_path:, relative_destination_path:)
      @relative_source_path = Pathname.new(relative_source_path)
      @relative_destination_path = Pathname.new(relative_destination_path)
    end
  end
end
