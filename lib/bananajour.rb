libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'yaml'
require 'fancypath'
require 'ostruct'
require 'rainbow'
require 'socket'

module Bananajour
  def self.path
    Fancypath(File.expand_path("~/.bananajour"))
  end
  def self.config_path
    path/"config.yml"
  end
  def self.repositories_path
    path/"repositories"
  end
  def self.config
    OpenStruct.new(YAML.load(config_path.read))
  end
  def self.setup?
    config_path.exists?
  end
  def self.setup!
    path.create_dir
    repositories_path.create_dir
    puts "Holy bananarama! I don't think we've met."
    puts
    name = ""
    while name.length == 0 do
      print "Your name plz? ".foreground(:yellow)
      name = (STDIN.gets || "").strip
    end
    config_path.write({"name" => name}.to_yaml)
    puts
    puts "Nice to meet you #{name}, I'm Bananajour."
    puts
    puts "You can add a project using 'bananajour add' in your project's dir."
    puts
  end
  def self.serve_web!
    Thread.new { `/usr/bin/env ruby #{File.dirname(__FILE__)}/../sinatra/app.rb -p 90210` }
    puts "* Started " + "http://#{host_name}:90210/".foreground(:yellow)
  end
  def self.serve_git!
    Thread.new { `git-daemon --base-path=#{repositories_path} --export-all` }
    puts "* Started " + "#{git_uri}".foreground(:yellow)
  end
  def self.host_name
    Socket.gethostname
  end
  def self.git_uri
    "git://#{host_name}/"
  end
  def self.advertise!
    puts "* Advertising on bonjour"
    # TODO:
  end
  def self.add!(name)
    unless File.directory?(".git")
      STDERR.puts "Can't add project #{File.expand_path(".")}, no .git directory found."
      exit(1)
    end

    repo = name ? Repository.for_name(name) : Repository.for_working_path(Fancypath("."))

    if repo.exists?
      STDERR.puts "You've already a project #{repo}."
      exit(1)
    end

    repo.init!
    `git remote add banana #{repo.path.expand_path}`
    puts added_success_message(repo.dirname)
  end
  def self.added_success_message(repo_dirname)
    "Repo #{repo_dirname} added. To get started: git push banana master"
  end
  def self.repositories
    repositories_path.children.map {|r| Repository.new(r)}.sort_by {|r| r.name}
  end
  def self.repository(name)
    repositories.find {|r| r.name == name}
  end
end

require 'bananajour/repository'