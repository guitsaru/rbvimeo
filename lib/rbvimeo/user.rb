# <owner display_name="Vimeo Staff" id="152184" is_plus="1" is_staff="1" profileurl="http://vimeo.com/staff" realname="Vimeo Staff" username="staff" videosurl="http://vimeo.com/staff/videos">

module RBVIMEO
  class User
    attr_accessor :id, :username, :display_name, :is_plus, :is_staff, :profileurl, :realname, :username, :videosurl

    def id
      @id.to_i
    end

    def fullname
      @realname
    end
  end
end