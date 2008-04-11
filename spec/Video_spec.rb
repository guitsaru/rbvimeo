require File.join(File.dirname(__FILE__), %w[spec_helper])
require File.join(File.dirname(__FILE__), "../lib/rbVimeo.rb")
require File.join(File.dirname(__FILE__), "../lib/Video.rb")
require "yaml"

include RBVIMEO

#     assert_equal(152184, vid.owner.id)
#     assert_equal("staff", vid.owner.username)
#     assert_equal("Vimeo Staff", vid.owner.fullname)
#     assert_equal("http://www.vimeo.com/339189/l:app-230", vid.url)
#     assert_equal(
#       "http://40.media.vimeo.com/d1/5/36/63/98/thumbnail-36639824.jpg",
#       vid.thumbs[0].url)
#     assert_equal(96, vid.thumbs[0].width)
#     assert_equal(72, vid.thumbs[0].height)

describe Video, "initialization" do
  before(:all) do
    test_settings_file = File.join(File.dirname(__FILE__), %w[test_settings.yml])
    test_video_xml_file = File.join(File.dirname(__FILE__), %w[XML/339189.xml])
    test_settings = YAML.load_file(test_settings_file)
    @api_key = test_settings['api_key']
    @api_secret = test_settings['api_secret']
    @vimeo = RBVIMEO::Vimeo.new(@api_key, @api_secret)
    @vid = @vimeo.video(339189, test_video_xml_file)
  end
  
  it "should have title" do
    @vid.title.should eql("Upload Tutorial")
  end
  
  it "should have caption" do
    @vid.caption.should eql("This is a tutorial about our new Uploader. Enjoy!")
  end
  
  it "should have upload date" do
    @vid.upload_date.should eql("2007-10-12 16:30:32")
  end
  
  it "should have likes" do
    @vid.likes.should eql(174)
  end
  
  it "should have plays" do
    @vid.plays.should eql(515407)
  end
  
  it "should have dimensions" do
    @vid.width.should eql(506)
    @vid.height.should eql(380)
  end

  it "should have comments" do
    @vid.num_comments.should eql(34)
    @vid.comments[0].id.should eql(265313)
    @vid.comments[0].author.should eql("ctd3")
    @vid.comments[0].authorname.should eql("CTD3")
    @vid.comments[0].date.should eql("2007-10-12 17:47:13")
    @vid.comments[0].url.should eql("http://www.vimeo.com/339189#comment_265313")
    @vid.comments[0].text.should eql("Sure is! Great changes!")
  end

  it "should have owner" do
    @vid.owner.id.should eql(152184)
    @vid.owner.username.should eql("staff")
    @vid.owner.fullname.should eql("Vimeo Staff")
  end
  
  it "should have url" do
    @vid.url.should eql("http://www.vimeo.com/339189/l:app-230")
  end

  it "should have thumbnails" do
    @vid.thumbs[0].url.should eql("http://40.media.vimeo.com/d1/5/36/63/98/thumbnail-36639824.jpg")
    @vid.thumbs[0].width.should eql(96)
    @vid.thumbs[0].height.should eql(72)
  end
end