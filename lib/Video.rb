require 'net/http'
require 'rexml/document'
require File.join(File.dirname(__FILE__), %w[rbVimeo])
require File.join(File.dirname(__FILE__), %w[User])
require File.join(File.dirname(__FILE__), %w[Thumbnail])
require File.join(File.dirname(__FILE__), %w[Comment])

module RBVIMEO
  class Video
    attr_reader :id, :title, :caption, :upload_date, :likes, :plays
    attr_reader :num_comments, :width, :height, :owner, :tags, :url
    attr_reader :thumbs, :comments
    
    # Fetches data about a video from the Vimeo site
    # id is the id of the the Vimeo video
    # vimeo is an instance of RBVIMEO::Vimeo
    #
    # To load a movie with vimeo id 339189:
    # @vimeo = RBVIMEO::Vimeo.new api_key, api_secret
    # video = RBVIMEO::Video.new 339189, @vimeo
    def initialize id, vimeo, xml=nil
      @thumbs = Array.new
      @comments = Array.new
      @id = id
      url = vimeo.generate_url({"method" => "vimeo.videos.getInfo", 
        "video_id" => id, "api_key" => vimeo.api_key}, "read")
      unless xml
        xml_data = Net::HTTP.get_response(URI.parse(url)).body
      else
        xml_data = File.open(xml)
      end
      xml_doc = REXML::Document.new(xml_data)
      
      return @id = -1 if parse_xml(xml_doc).nil?
      get_comments id, vimeo, xml
    
    end
  
    # Parses data using the xml recieved from the Vimeo REST API
    # Should not need to be called by anything other than the initialize method
    def parse_xml xml_doc
      if xml_doc.elements["rsp/video/title"].nil?
        return nil
      else
        @title = xml_doc.elements["rsp/video/title"].text
        @id = id
        @caption = xml_doc.elements["rsp/video/caption"].text
        @upload_date = xml_doc.elements["rsp/video/upload_date"].text
        @likes = xml_doc.elements["rsp/video/number_of_likes"].text.to_i
        @plays = xml_doc.elements["rsp/video/number_of_plays"].text.to_i
        @width = xml_doc.elements["rsp/video/width"].text.to_i
        @height = xml_doc.elements["rsp/video/height"].text.to_i
        @num_comments =
          xml_doc.elements["rsp/video/number_of_comments"].text.to_i
        @owner = User.new
        @owner.id = xml_doc.elements["rsp/video/owner"].attributes["id"].to_i
        @owner.username =
          xml_doc.elements["rsp/video/owner"].attributes["username"]
        @owner.fullname =
          xml_doc.elements["rsp/video/owner"].attributes["fullname"]
        @url = xml_doc.elements["rsp/video/urls/url"].text
      
        xml_doc.elements.each('rsp/video/thumbnails/thumbnail') do |thumb|
          url = thumb.text
          w = thumb.attributes["width"].to_i
          h = thumb.attributes["height"].to_i
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
    # @vimeo = RBVIMEO::Vimeo.new api_key, api_secret
    # comments = video.comments 339189, @vimeo
    def get_comments id, vimeo, xml=nil
      comments = Array.new
      url = vimeo.generate_url({"method" => "vimeo.videos.comments.getList",
        "video_id" => id, "api_key" => vimeo.api_key}, "read")
      unless xml
        xml_data = Net::HTTP.get_response(URI.parse(url)).body
      else
        xml_data = File.open(File.join(File.dirname(xml), File.basename(xml, '.xml')+'.comments.xml'))
      end
      xml_doc = REXML::Document.new(xml_data)
    
      xml_doc.elements.each('rsp/comments/comment') do |comment|
        id = comment.attributes["id"].to_i
        author = comment.attributes["author"]
        authorname = comment.attributes["authorname"]
        date = comment.attributes["datecreate"]
        url = comment.attributes["permalink"]
        text = comment.text
        com = Comment.new(id, author, authorname, date, url, text)
        @comments << com
      end
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
      string += '&amp;server=www.vimeo.com&amp;fullscreen=1&amp;show_title=0'
      string += '&amp;show_byline=0&amp;showportrait=0&amp;color=00ADEF">'
      string += '<param name="quality" value="best" />'
      string += '<param name="allowfullscreen" value="true" />'
      string += '<param name="scale" value="showAll" />'
      string += '<param name="movie" value="http://www.vimeo.com/moogaloop.swf?clip_id='
      string += id + '&amp;server=www.vimeo.com&amp;fullscreen=1&amp;'
      string += 'show_title=0&amp;show_byline=0&amp;showportrait=0&amp;color=00ADEF" /></object>'
  
      return string
    end
  end
end