require 'rubygems'
require 'hpricot'
require 'open-uri'

require File.join(File.dirname(__FILE__), %w[rbVimeo])
require File.join(File.dirname(__FILE__), %w[User])
require File.join(File.dirname(__FILE__), %w[Thumbnail])
require File.join(File.dirname(__FILE__), %w[Comment])

module RBVIMEO
  class Video
    attr_reader :id, :title, :caption, :upload_date, :likes, :plays
    attr_reader :num_comments, :width, :height, :owner, :tags, :url
    attr_reader :thumbs
    
    # Fetches data about a video from the Vimeo site
    # id is the id of the the Vimeo video
    # vimeo is an instance of RBVIMEO::Vimeo
    #
    # To load a movie with vimeo id 339189:
    # @vimeo = RBVIMEO::Vimeo.new api_key, api_secret
    # video = RBVIMEO::Video.new 339189, @vimeo
    def initialize id, vimeo, xml=nil
      @thumbs = []
      @comments = []
      @id = id
      @vimeo = vimeo
      
      url = vimeo.generate_url({"method" => "vimeo.videos.getInfo", 
        "video_id" => id, "api_key" => vimeo.api_key}, "read")
      unless xml
        #does not get covered by specs because we get an internal xml file
        xml_doc = Hpricot(open(url))
      else
        xml_doc = open(xml) {|file| Hpricot(file)}
      end
      
      return @id = -1 if parse_xml(xml_doc).nil?
    end
  
    # Parses data using the xml recieved from the Vimeo REST API
    # Should not need to be called by anything other than the initialize method
    def parse_xml xml_doc
      if xml_doc.at("title").nil?
        return nil
      else  
        @id = id
        @title = xml_doc.at("title").inner_html
        @caption = xml_doc.at("caption").inner_html
        @upload_date = xml_doc.at("upload_date").inner_html
        @likes = xml_doc.at("number_of_likes").inner_html.to_i
        @plays = xml_doc.at("number_of_plays").inner_html.to_i
        @width = xml_doc.at("width").inner_html.to_i
        @height = xml_doc.at("height").inner_html.to_i
        @num_comments = xml_doc.at("number_of_comments").inner_html.to_i
        
        @owner = User.new
        @owner.id = xml_doc.at("owner").attributes["id"].to_i
        @owner.username = xml_doc.at("owner").attributes["username"]
        @owner.fullname = xml_doc.at("owner").attributes["fullname"]
          
        @url = xml_doc.at("url").inner_html

        (xml_doc/:thumbnail).each do |thumbnail|
          url = thumbnail.inner_html
          w = thumbnail.attributes['width'].to_i
          h = thumbnail.attributes['height'].to_i
          thumbnail = Thumbnail.new(url, w, h)
          @thumbs << thumbnail
        end
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
    def get_comments xml=nil
      comments = []
      url = @vimeo.generate_url({"method" => "vimeo.videos.comments.getList",
        "video_id" => @id, "api_key" => @vimeo.api_key}, "read")
        
      unless @xml
        #does not get covered by specs because we get an internal xml file
        xml_doc = Hpricot.XML(open(url))
      else
        xml_doc = open(@xml) {|file| Hpricot.XML(file)}
      end
      
      (xml_doc/:comment).each do |comment|
        text = comment.children.select{|e| e.text?}.join
        id = comment.attributes['id'].to_i
        author = comment.attributes['author']
        authorname = comment.attributes['authorname']
        date = comment.attributes['datecreate']
        url = comment.attributes['permalink']
        
        @portraits = []
        (comment/'portraits'/'portrait').each do |thumb|
          portrait_url = thumb.inner_html          
          w = thumb.attributes['width'].to_i
          h = thumb.attributes['height'].to_i
          thumbnail = Thumbnail.new(portrait_url, w, h)
          @portraits << thumbnail
        end
        com = Comment.new(id, author, authorname, date, url, text, @portraits)
        @comments << com
      end
      return self
    end

    # Returns the code to embed the video
    def embed width, height
      w = width.to_s
      h = height.to_s
      id = @id.to_s
      string = ''
      string += '<object type="application/x-shockwave-flash" width='
      string += w + '" height="' + h + '"'
      string += 'data="http://www.vimeo.com/moogaloop.swf?clip_id=' + id
      string += '&amp;server=www.vimeo.com&amp;fullscreen=0&amp;show_title=0'
      string += '&amp;show_byline=0&amp;showportrait=0&amp;color=00ADEF">'
      string += '<param name="quality" value="best" />'
      string += '<param name="allowfullscreen" value="false" />'
      string += '<param name="scale" value="showAll" />'
      string += '<param name="movie" value="http://www.vimeo.com/moogaloop.swf?clip_id='
      string += id + '&amp;server=www.vimeo.com&amp;fullscreen=0&amp;'
      string += 'show_title=0&amp;show_byline=0&amp;showportrait=0&amp;color=00ADEF" /></object>'
  
      return string
    end
  
    def comments xml=nil
      get_comments(xml) if @comments.empty?
      return @comments
    end
  end
end