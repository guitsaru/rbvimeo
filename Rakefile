# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'rbVimeo'

task :default => 'spec:run'

PROJ.name = 'rbVimeo'
PROJ.authors = 'Matt Pruitt'
PROJ.email = 'guitsaru@gmail.com'
PROJ.url = 'www.guitsaru.com'
PROJ.rubyforge_name = 'rbVimeo'

PROJ.spec_opts << '--color'

# EOF
