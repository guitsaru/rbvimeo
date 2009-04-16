module RBVIMEO
  class Comment
    attr_accessor :id, :author, :authorname, :datecreate, :permalink, :text, :portraits
    
    def initialize
      @portraits = []
    end
    
    def date
      return @datecreate
    end
    
    def url
      return @permalink
    end
    
    def id
      return @id.to_i
    end
  end
end