# $Id$

require 'rake/rdoctask'

namespace :doc do

  desc 'Generate RDoc documentation'
  Rake::RDocTask.new do |rd|
    rd.main = PROJ.rdoc.main
    rd.rdoc_dir = PROJ.rdoc.dir

    incl = Regexp.new(PROJ.rdoc.include.join('|'))
    excl = Regexp.new(PROJ.rdoc.exclude.join('|'))
    files = PROJ.gem.files.find_all do |fn|
              case fn
              when excl; false
              when incl; true
              else false end
            end
    rd.rdoc_files.push(*files)

    title = "#{PROJ.name}-#{PROJ.version} Documentation"
    title = "#{PROJ.rubyforge.name}'s " + title if PROJ.rubyforge.name != title

    rd.options << "-t #{title}"
    rd.options.concat(PROJ.rdoc.opts)
  end

  desc 'Generate ri locally for testing'
  task :ri => :clobber_ri do
    sh "#{RDOC} --ri -o ri ."
  end

  task :clobber_ri do
    rm_r 'ri' rescue nil
  end

end  # namespace :doc

desc 'Alias to doc:rdoc'
task :doc => 'doc:rdoc'

desc 'Remove all build products'
task :clobber => %w(doc:clobber_rdoc doc:clobber_ri)

remove_desc_for_task %w(doc:clobber_rdoc)

# EOF
