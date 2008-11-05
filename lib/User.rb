module RBVIMEO
  class User
    attr_accessor :id, :username, :fullname
    
    def id
      return @id.to_i
    end
  end
end