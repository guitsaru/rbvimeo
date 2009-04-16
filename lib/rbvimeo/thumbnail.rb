module RBVIMEO
  class Thumbnail
    attr_accessor :url, :width, :height
    def initialize(url, width, height)
      @url = url
      @width = width
      @height = height
    end
  end
end