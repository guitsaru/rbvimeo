require "test/unit"

require '/Users/Matt/Documents/Code/Ruby/rbVimeo/lib/User'
require '/Users/Matt/Documents/Code/Ruby/rbVimeo/lib/rbVimeo'

class TestUser < Test::Unit::TestCase
  def setup
    @api_key = "56a9c1c65e700ca10a678a2bcd8e77af"
    @api_secret = "59c629610"
    @vimeo = RBVIMEO::Vimeo.new(@api_key, @api_secret)
    @user = @vimeo.user
  end
  def test_authenticate
    @user.authentication("delete", @vimeo)
    assert_not_equal(nil, @user.frob)
    assert_no_match(/http:\/\//, @user.frob)
    assert_match(/http:\/\//, @user.login_link)
    assert_not_equal(nil, @user.token)
  end
end