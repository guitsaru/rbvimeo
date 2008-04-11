require "test/unit"

require File.dirname(__FILE__) + "/../lib/rbVimeo.rb"

class TestLibRbVimeo < Test::Unit::TestCase
  def setup
    @api_key = "56a9c1c65e700ca10a678a2bcd8e77af"
    @api_secret = "59c629610"
    @vimeo = RBVIMEO::Vimeo.new(@api_key, @api_secret)
  end
  
  def test_initialize
    assert_equal(@api_key, @vimeo.api_key)
    assert_equal(@api_secret, @vimeo.api_secret)
  end
  
  def test_generate_signature
    params = {"method" => "vimeo.videos.getInfo", 
      "video_id" => "339189", "api_key" => @vimeo.api_key}
    assert_equal("09cc6d8b963c73caf647e436b2147810", 
      @vimeo.generate_signature(params))
  end
  
  def test_generate_url
    assert_equal("http://www.vimeo.com/api/rest?api_key=" + @api_key + "&method=vimeo.videos.getInfo&video_id=339189&api_sig=09cc6d8b963c73caf647e436b2147810", \
      @vimeo.generate_url({"method" => "vimeo.videos.getInfo", 
        "video_id" => "339189", "api_key" => @vimeo.api_key}), "read")
  end
end