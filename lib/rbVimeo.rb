# Matt Pruitt
# Ruby Library for working with Vimeo
# Based on the sample PHP Vimeo API

require 'digest/md5'
require 'net/http'
require 'rexml/document'
require File.join(File.dirname(__FILE__), %w[Video])

module RBVIMEO
  class Vimeo
    attr_accessor :api_key, :api_secret
  
    @@API_REST_URL  = "http://www.vimeo.com/api/rest"
    @@API_AUTH_URL   = "http://www.vimeo.com/services/auth/"
    @@API_UPLOAD_URL = "http://www.vimeo.com/services/upload/"
    
    # api_key and api_secret should both be generated on www.vimeo.com
    def initialize api_key, api_secret
      @api_key = api_key
      @api_secret = api_secret
    end

    # @vimeo.generate_url({"method" => "vimeo.videos.getInfo", "read",
    #   "video_id" => "339189", "api_key" => @vimeo.api_key})
    # This example returns a url to the xml for the Vimeo video with id 339189
    def generate_url parameters, permissions = nil
      url = "#{@@API_REST_URL}?api_key=#{@api_key}"
      params = parameters.sort
      params.each do |param|
        url += "&#{param[0]}=#{param[1]}" unless param[0].to_s == "api_key"
      end
      url += "&api_sig=#{generate_signature(parameters)}"
      return url
    end
    
    # parameters is a hash 
    def generate_signature parameters
      temp = ''
      params = parameters.sort
      params.each do |array|
        temp += array[0].to_s + array[1].to_s
      end
      signature = @api_secret + temp
      Digest::MD5.hexdigest(signature)
    end
    
    # Provides easier access to RBVIMEO::Video
    # video = @vimeo.video 339189
    def video id, xml=nil
      vid = Video.new(id, self, xml)
      return nil if vid.id == -1
      return vid
    end
    
    # Provides easier access to RBVIMEO::User
    # user = @vimeo.user
    def user
      return User.new
    end
  end
end