require 'test_helper'

class VideoTest < Test::Unit::TestCase
  context "initialization" do
    setup do
      @api_key = '56a9c1c65e700ca10a678a2bcd8e77af'
      @api_secret = '59c629610'
      @vimeo = RBVIMEO::Vimeo.new(@api_key, @api_secret)
      @params = {"method" => "vimeo.videos.getInfo", "video_id" => "339189", "api_key" => @api_key}
    end

    context "a valid video" do
      setup do
        test_video_xml_file = File.join(File.dirname(__FILE__), %w[XML/339189.xml])

        video_hpricot = open(test_video_xml_file) {|file| Hpricot(file)}
        @vimeo.stubs(:get_xml).returns(video_hpricot)

        @vid = @vimeo.video(339189)
      end

      should "have a title" do
        assert_equal("Upload Tutorial", @vid.title.chomp)
      end

      should "have a description" do
        assert_equal("This is a tutorial about our new Uploader. Enjoy! \nNote- If you have problems uploading post a message here, http://www.vimeo.com/forum:known_issues under problems uploading and we'll help you.", @vid.description.chomp)
      end

      should "have an upload date" do
        assert_equal("2007-10-12 16:30:32", @vid.upload_date)
      end

      should "have likes" do
        assert_equal(542, @vid.likes)
        assert_equal(542, @vid.number_of_likes)
      end

      should "have plays" do
        assert_equal(145299, @vid.plays)
        assert_equal(145299, @vid.number_of_plays)
      end

      should "have a duration" do
        assert_equal(333, @vid.duration)
      end

      should "have comments" do
        test_video_xml_file = File.join(File.dirname(__FILE__), %w[XML/339189.comments.xml])

        comment_hpricot = open(test_video_xml_file) {|file| Hpricot(file)}
        @vimeo.stubs(:get_xml).returns(comment_hpricot)

        assert_equal(166, @vid.num_comments)
        assert_equal(166, @vid.number_of_comments)
        assert_equal(265313, @vid.comments[0].id)
        assert_equal("ctd3", @vid.comments[0].author)
        assert_equal("CTD3", @vid.comments[0].authorname)
        assert_equal("2007-10-12 17:47:13", @vid.comments[0].date)
        assert_equal("http://www.vimeo.com/339189#comment_265313", @vid.comments[0].url)
        assert_match(/Sure is! Great changes!/, @vid.comments[0].text)
        assert_equal("http://80.media.vimeo.com/d1/5/35/44/42/portrait-35444268.jpg", @vid.comments[0].portraits[0].url)
        assert_equal(24, @vid.comments[0].portraits[0].width)
        assert_equal(24, @vid.comments[0].portraits[0].height)
      end

      should "have an owner" do
        assert_equal(152184, @vid.owner.id)
        assert_equal("staff", @vid.owner.username)
        assert_equal("Vimeo Staff", @vid.owner.fullname)
      end

      should "have a url" do
        assert_equal("http://vimeo.com/339189", @vid.url)
      end

      should "have a thumbnail" do
        assert_equal("http://ats.vimeo.com/210/131/21013194_100.jpg", @vid.thumbs[0].url)
        assert_equal(100, @vid.thumbs[0].width)
        assert_equal(75, @vid.thumbs[0].height)
      end

      should "have embed code" do
        assert_not_nil(@vid.embed(240, 480))
      end
    end

    context "an invalid video" do
      setup do
        not_found_xml_file = File.join(File.dirname(__FILE__), %w[XML/not_found.xml])

        video_hpricot = open(not_found_xml_file) {|file| Hpricot(file)}
        @vimeo.stubs(:get_xml).returns(video_hpricot)

        @vid = @vimeo.video(-34)
      end

      should "return nil on nonexistant video" do
        assert_nil(@vid)
      end
    end

  end
end