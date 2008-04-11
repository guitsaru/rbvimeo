module RBVIMEO
  class Comment
    attr_accessor :id, :author, :authorname, :date, :url, :text, :portraits
    def initialize(id, author, authorname, date, url, text, portraits)
      @id = id
      @author = author
      @authorname = authorname
      @date = date
      @url = url
      @text = text.chomp.strip
      @portraits = portraits
    end
  end
end