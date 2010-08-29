lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

desc "Boot up bananajour"
task :default do
  exec "bundle exec bin/bananajour"
end

desc "Boot up just the web interface"
task :web do
  exec "bundle exec ruby -I#{lib} sinatra/app.rb -p 4567 -s thin"
end

require "bananajour/version"
version = Bananajour::VERSION
gem_name = "bananajour-#{version}.gem"

desc "Build #{gem_name} into pkg"
task :build do
  system "gem build bananajour.gemspec"
end

desc "Tag and push #{gem_name}"
task :push => :build do
  abort "Push failed: #{version} already tagged. Do you need to bump the version?" if `git tag`.split.include?(version)
  system "git tag #{version} && git push --all && git push --tags && gem push #{gem_name}"
end
