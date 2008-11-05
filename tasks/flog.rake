namespace :flog do
  task :default => :run

  desc "Run Flog"
  task :run do
    `find lib -name \*.rb | xargs flog  > flog.txt`
  end

end