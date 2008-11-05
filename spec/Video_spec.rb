require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'yaml'

include RBVIMEO

describe Video, "initialization" do
  before(:all) do
    test_settings_file = File.join(File.dirname(__FILE__), %w[test_settings.yml])
    test_settings = YAML.load_file(test_settings_file)
    @api_key = test_settings['api_key']
    @api_secret = test_settings['api_secret']
    
    @vimeo = RBVIMEO::Vimeo.new(@api_key, @api_secret)
  end
  
  context "A Valid Video" do
    before(:all) do
      test_video_xml_file = File.join(File.dirname(__FILE__), %w[XML/339189.xml])
      
      video_hpricot = open(test_video_xml_file) {|file| Hpricot(file)}
      @vimeo.stub!(:get_xml).and_return(video_hpricot)

      @vid = @vimeo.video(339189)
    end
    
    it "should have title" do
      @vid.title.chomp.should eql("Upload Tutorial")
    end
  
    it "should have caption" do
      @vid.caption.chomp.should eql("This is a tutorial about our new Uploader. Enjoy!")
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
      test_video_xml_file = File.join(File.dirname(__FILE__), %w[XML/339189.comments.xml])
      
      comment_hpricot = open(test_video_xml_file) {|file| Hpricot(file)}
      @vimeo.stub!(:get_xml).and_return(comment_hpricot)
      
      @vid.num_comments.should eql(34)
      @vid.comments[0].id.should eql(265313)
      @vid.comments[0].author.should eql("ctd3")
      @vid.comments[0].authorname.should eql("CTD3")
      @vid.comments[0].date.should eql("2007-10-12 17:47:13")
      @vid.comments[0].url.should eql("http://www.vimeo.com/339189#comment_265313")
      @vid.comments[0].text.should match(/Sure is! Great changes!/)
      @vid.comments[0].portraits[0].url.should eql("http://80.media.vimeo.com/d1/5/35/44/42/portrait-35444268.jpg")
      @vid.comments[0].portraits[0].width.should eql(24)
      @vid.comments[0].portraits[0].height.should eql(24)
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

    it "should give an embed link" do
      @vid.embed(240, 480).should_not be_nil
    end
  end
  
  context "An Invalid Video" do
    setup do
      not_found_xml_file = File.join(File.dirname(__FILE__), %w[XML/not_found.xml])
      
      video_hpricot = open(not_found_xml_file) {|file| Hpricot(file)}
      @vimeo.stub!(:get_xml).and_return(video_hpricot)

      @vid = @vimeo.video(-34)
    end
    
    it "should return nil on nonexistent video" do
      video = @vimeo.video(99999999999)
      video.should be_nil
    end
  end
end