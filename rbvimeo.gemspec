(in /Users/Matt/Documents/Code/Ruby/rbVimeo)
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rbvimeo}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Pruitt"]
  s.date = %q{2008-11-17}
  s.default_executable = %q{rbVimeo}
  s.description = %q{}
  s.email = %q{guitsaru@gmail.com}
  s.executables = ["rbVimeo"]
  s.extra_rdoc_files = ["History.txt", "bin/rbVimeo"]
  s.files = ["History.txt", "Manifest.txt", "README.textile", "Rakefile", "bin/rbVimeo", "lib/rbVimeo.rb", "lib/Comment.rb", "lib/Thumbnail.rb", "lib/User.rb", "lib/Video.rb", "spec/rbVimeo_spec.rb", "spec/sample_test_settings.yml", "spec/Video_spec.rb", "spec/XML/339189.comments.xml", "spec/XML/339189.xml", "spec/XML/not_found.xml", "spec/spec_helper.rb", "tasks/ann.rake", "tasks/annotations.rake", "tasks/bones.rake", "tasks/doc.rake", "tasks/gem.rake", "tasks/manifest.rake", "tasks/post_load.rake", "tasks/rubyforge.rake", "tasks/setup.rb", "tasks/spec.rake", "tasks/svn.rake"]
  s.has_rdoc = true
  s.homepage = %q{www.guitsaru.com}
  s.rdoc_options = ["--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rbvimeo}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A ruby wrapper for the vimeo api}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0"])
  end
end
