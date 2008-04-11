require 'rbVimeo'
require 'net/http'
require 'rexml/document'

module RBVIMEO
  class User
    attr_accessor :id, :username, :fullname
    attr_reader :frob, :login_link, :token, :permission
    
    def authentication permission, vimeo
      desktop_authentication permission, vimeo
    end
    def desktop_authentication permission, vimeo
      get_frob vimeo
      get_login_link permission, vimeo
      get_token vimeo
    end
    def get_frob vimeo
      url = vimeo.generate_url({"method" => "vimeo.auth.getFrob", 
        "api_key" => vimeo.api_key.to_s})
      xml_data = Net::HTTP.get_response(URI.parse(url)).body
      xml_doc = REXML::Document.new(xml_data)
      return nil if xml_doc.elements["rsp/frob"].nil?
      @frob = xml_doc.elements["rsp/frob"].text
      self
    end
    def get_login_link permission, vimeo
      @login_link = "http://www.vimeo.com/services/auth/" + "?api_key=" + 
        vimeo.api_key.to_s + "&perms=" + permission + "&frob=" + frob + 
        "&api_sig=" + vimeo.generate_signature({"api_key" =>
        vimeo.api_key.to_s, "perms" => permission, "frob" => frob})
      self
    end
    def get_token vimeo
      puts @login_link
      puts
      puts "Press enter after you click continue on the above link."
      temp = gets
      url = vimeo.generate_url({"method" => "vimeo.auth.getToken", "api_key" =>
            vimeo.api_key.to_s, "frob" => @frob})
      puts url
      xml_data = Net::HTTP.get_response(URI.parse(url)).body
      xml_doc = REXML::Document.new(xml_data)
      @token = xml_doc.elements["rsp/auth/token"]
      @permission = xml_doc.elements["rsp/auth/perms"]
      @id = xml_doc.elements["rsp/auth/user"].attributes["id"]
      @username = xml_doc.elements["rsp/auth/user"].attributes["username"]
      @fullname = xml_doc.elements["rsp/auth/user"].attributes["fullname"]
      self
    end
  end
end