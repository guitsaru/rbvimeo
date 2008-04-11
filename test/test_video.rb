require "test/unit"

require File.dirname(__FILE__) + '/../lib/Video.rb'
require File.dirname(__FILE__) + '/../lib/rbVimeo.rb'

class TestLibVideo < Test::Unit::TestCase
  def setup
    @api_key = "56a9c1c65e700ca10a678a2bcd8e77af"
    @api_secret = "59c629610"
    @vimeo = RBVIMEO::Vimeo.new(@api_key, @api_secret)
  end
  def test_initialize
    vid = @vimeo.video(339189)
    params = {"method" => "vimeo.videos.comments.getList", 
      "video_id" => "339189", "api_key" => @vimeo.api_key}
      
    assert_equal("Upload Tutorial", vid.title)
    assert_equal("This is a tutorial about our new Uploader. Enjoy!", 
      vid.caption)
    assert_equal("2007-10-12 16:30:32", vid.upload_date)
    assert(vid.likes > 114)
    #Views can't go down, checks that it's greater than the initial value
    assert(vid.plays > 414456)
    assert_equal(506, vid.width)
    assert_equal(380, vid.height)
    assert(vid.num_comments > 32)
    assert_equal(152184, vid.owner.id)
    assert_equal("staff", vid.owner.username)
    assert_equal("Vimeo Staff", vid.owner.fullname)
    assert_equal("http://www.vimeo.com/339189/l:app-230", vid.url)
    assert_equal(
      "http://40.media.vimeo.com/d1/5/36/63/98/thumbnail-36639824.jpg",
      vid.thumbs[0].url)
    assert_equal(96, vid.thumbs[0].width)
    assert_equal(72, vid.thumbs[0].height)
    assert_equal(265313, vid.comments[0].id)
    assert_equal("ctd3", vid.comments[0].author)
    assert_equal("CTD3", vid.comments[0].authorname)
    assert_equal("2007-10-12 17:47:13", vid.comments[0].date)
    assert_equal("http://www.vimeo.com/339189#comment_265313", vid.comments[0].url)
    assert_equal("Sure is! Great changes!", vid.comments[0].text)
  end
  def test_private_unauthorized
    vid = @vimeo.video(808655)
    assert_equal(nil, vid)
  end
  def test_no_video
    vid = @vimeo.video(1808655)
    assert_equal(nil, vid)
  end
end