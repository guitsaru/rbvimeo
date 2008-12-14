require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

class TestRbVimeo < Test::Unit::TestCase
  context "Vimeo" do
    setup do
      @api_key = '56a9c1c65e700ca10a678a2bcd8e77af'
      @api_secret = '59c629610'
      @vimeo = RBVIMEO::Vimeo.new(@api_key, @api_secret)
      @params = {"method" => "vimeo.videos.getInfo", "video_id" => "339189", "api_key" => @api_key}
    end
    
    should "initialize" do
      assert_not_nil(@api_key)
      assert_not_nil(@api_secret)
    end
    
    should "generate a signature" do
      assert_equal("09cc6d8b963c73caf647e436b2147810", @vimeo.generate_signature(@params))
    end
    
    should "generate a url" do
      assert_equal("http://www.vimeo.com/api/rest?api_key=#{@api_key}&method=vimeo.videos.getInfo&video_id=339189&api_sig=09cc6d8b963c73caf647e436b2147810", @vimeo.generate_url(@params, "read"))
    end
    
    should "generate a video" do
      test_video_xml_file = File.join(File.dirname(__FILE__), %w[XML/339189.xml])

      video_hpricot = open(test_video_xml_file) {|file| Hpricot(file)}
      @vimeo.stubs(:get_xml).returns(video_hpricot)

      @vid = @vimeo.video(339189)
      
      assert_not_nil(@vid)
    end
    
    should "generate a user" do
      assert_not_nil(@vimeo.user)
    end
    
    should "return an xml file" do
      test_video_xml_file = File.join(File.dirname(__FILE__), %w[XML/339189.xml])

      video_hpricot = open(test_video_xml_file) {|file| Hpricot(file)}
      @vimeo.stubs(:get_xml).returns(video_hpricot)
      
      assert_not_nil(@vimeo.get_xml(@vimeo.generate_url(@params, "read")).at('video'))
    end
  end
end