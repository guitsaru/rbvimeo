module RBVIMEO
  class Comment
    attr_accessor :id, :author, :authorname, :date, :url, :text
    def initialize(id, author, authorname, date, url, text)
      @id = id
      @author = author
      @authorname = authorname
      @date = date
      @url = url
      @text = text.chomp.strip
    end
  end
end