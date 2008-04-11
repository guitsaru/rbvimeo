require File.join(File.dirname(__FILE__), %w[spec_helper])
require File.join(File.dirname(__FILE__), "../lib/rbVimeo.rb")
require File.join(File.dirname(__FILE__), "../lib/User.rb")
require "yaml"

include RBVIMEO

describe User do
  before(:all) do
    test_settings_file = File.join(File.dirname(__FILE__), %w[test_settings.yml])
    test_settings = YAML.load_file(test_settings_file)
    @api_key = test_settings['api_key']
    @api_secret = test_settings['api_secret']
    @vimeo = RBVIMEO::Vimeo.new(@api_key, @api_secret)
    @params = {"method" => "vimeo.videos.getInfo", "video_id" => "339189", "api_key" => @api_key}
  end
  
  
end
