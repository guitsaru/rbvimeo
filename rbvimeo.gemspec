# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rbvimeo}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Pruitt"]
  s.date = %q{2009-04-16}
  s.email = %q{guitsaru@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.textile"
  ]
  s.files = [
    "LICENSE",
    "README.textile",
    "Rakefile",
    "VERSION.yml",
    "lib/rbvimeo.rb",
    "lib/rbvimeo/comment.rb",
    "lib/rbvimeo/thumbnail.rb",
    "lib/rbvimeo/user.rb",
    "lib/rbvimeo/video.rb",
    "lib/rbvimeo/vimeo.rb",
    "test/XML/339189.comments.xml",
    "test/XML/339189.xml",
    "test/XML/not_found.xml",
    "test/rbvimeo_test.rb",
    "test/test_helper.rb",
    "test/video_test.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/guitsaru/rbvimeo}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rbvimeo}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A ruby wrapper for the vimeo api}
  s.test_files = [
    "test/rbvimeo_test.rb",
    "test/test_helper.rb",
    "test/video_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.6"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.6"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.6"])
  end
end
