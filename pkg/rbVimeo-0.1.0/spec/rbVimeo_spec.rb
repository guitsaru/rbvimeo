require File.join(File.dirname(__FILE__), %w[spec_helper])
require File.join(File.dirname(__FILE__), "../lib/rbVimeo.rb")
require "yaml"

include RBVIMEO

describe Vimeo do
  before(:all) do
    test_settings_file = File.join(File.dirname(__FILE__), %w[test_settings.yml])
    test_settings = YAML.load_file(test_settings_file)
    @api_key = test_settings['api_key']
    @api_secret = test_settings['api_secret']
    @vimeo = RBVIMEO::Vimeo.new(@api_key, @api_secret)
    @params = {"method" => "vimeo.videos.getInfo", "video_id" => "339189", "api_key" => @api_key}
  end
  
  it "should initialize" do
    @api_key.should_not be_nil
    @api_secret.should_not be_nil
  end
  
  it "should generate a signature" do
    @vimeo.generate_signature(@params).should eql("09cc6d8b963c73caf647e436b2147810")
  end
  
  it "should generate a url" do
    @vimeo.generate_url(@params, "read").should eql("http://www.vimeo.com/api/rest?api_key=" + @api_key + "&method=vimeo.videos.getInfo&video_id=339189&api_sig=09cc6d8b963c73caf647e436b2147810")
  end

  it "should generate a video" do
    test_video_xml_file = File.join(File.dirname(__FILE__), %w[XML/339189.xml])
    @vid = @vimeo.video(339189, test_video_xml_file)
  end

  it "should generate a user" do
    @vimeo.user.should_not be_nil
  end
end
