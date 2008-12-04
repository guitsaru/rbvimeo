require 'rubygems'
require 'hpricot'
require 'open-uri'

module RBVIMEO
  class Video
    attr_reader :id, :title, :caption, :upload_date, :number_of_likes, :number_of_plays
    attr_reader :number_of_comments, :width, :height, :owner, :tags, :url
    attr_reader :thumbs

    
    # Fetches data about a video from the Vimeo site
    # id is the id of the the Vimeo video
    # vimeo is an instance of RBVIMEO::Vimeo
    #
    # To load a movie with vimeo id 339189:
    # @vimeo = RBVIMEO::Vimeo.new api_key, api_secret
    # video = RBVIMEO::Video.new 339189, @vimeo
    def initialize id, vimeo
      @thumbs = []
      @comments = []
      @id = id
      @vimeo = vimeo
      
      url = vimeo.generate_url({"method" => "vimeo.videos.getInfo", 
        "video_id" => id, "api_key" => vimeo.api_key}, "read")

      xml_doc = @vimeo.get_xml(url)

      return @id = -1 if parse_xml(xml_doc).nil?
    end

    # Returns the code to embed the video
    def embed width, height
      string = <<EOF
<object type="application/x-shockwave-flash" width=#{width} height=#{height} data="http://www.vimeo.com/moogaloop.swf?clip_id=#{@id}&server=www.vimeo.com&fullscreen=0&show_title=0'&show_byline=0&showportrait=0&color=00ADEF">
<param name="quality" value="best" />
<param name="allowfullscreen" value="false" />
<param name="scale" value="showAll" />
<param name="movie" value="http://www.vimeo.com/moogaloop.swf?clip_id=#{@id}&server=www.vimeo.com&fullscreen=0&show_title=0&show_byline=0&showportrait=0&color=00ADEF" /></object>
EOF
    string.gsub("\n", "")
    end

    def comments
      get_comments if @comments.empty?
      return @comments
    end
    
    def likes
      @number_of_likes.to_i
    end
    
    def plays
      @number_of_plays.to_i
    end
    
    def num_comments
      @number_of_comments.to_i
    end
    
    def number_of_likes
      @number_of_likes.to_i
    end
    
    def number_of_plays
      @number_of_plays.to_i
    end
    
    def number_of_comments
      @number_of_comments.to_i
    end
    
    def height
      @height.to_i
    end
    
    def width
      @width.to_i
    end
  
  private
    # Parses data using the xml recieved from the Vimeo REST API
    # Should not need to be called by anything other than the initialize method
    def parse_xml xml_doc
      return nil if xml_doc.at("title").nil?
      @id = id
      
      %w[title caption upload_date number_of_likes number_of_plays width height number_of_comments url].each do |attribute|
        instance_variable_set("@#{attribute}", xml_doc.at(attribute).inner_html)
      end
      
      @owner = User.new
      %w[id username fullname].each do |attribute|
        @owner.instance_variable_set("@#{attribute}", xml_doc.at("owner").attributes[attribute])
      end

      (xml_doc/:thumbnail).each do |thumbnail|
        @thumbs << build_thumbnail(thumbnail)
      end
    end
  
    # Fetches the comments for the specified Video
    # id is the id of the Vimeo video
    # vimeo is an instance of RBVIMEO::Vimeo
    # returns an Array of comments
    #
    # To load a movie with vimeo id 339189:
    #
    # comments = video.comments 339189, @vimeo
    def get_comments
      xml_doc = @vimeo.get_xml(@vimeo.generate_url({"method" => "vimeo.videos.comments.getList",
        "video_id" => @id, "api_key" => @vimeo.api_key}, "read"))
      
      (xml_doc/:comment).each do |comment|  
        @comments << build_comment(comment)
      end
      return self
    end
    
    def build_comment(c)
      comment = Comment.new

      comment.text = c.children.select{|e| e.text?}.join
      
      %w[id author authorname datecreate permalink].each do |attribute|
        comment.instance_variable_set("@#{attribute}", c.attributes[attribute])
      end

      (c/'portraits'/'portrait').each do |portrait|
        comment.portraits << build_thumbnail(portrait)
      end
      
      return comment
    end
    
    def build_thumbnail(t)
      thumbnail = Thumbnail.new(t.inner_html, t.attributes['width'].to_i, t.attributes['height'].to_i)
    end
    
  end
end