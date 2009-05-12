gem 'mojombo-grit'
require 'grit'

module Bananajour
  class Repository
    def self.for_name(name)
      new(Bananajour.repositories_path / (name + ".git"))
    end
    def self.for_working_path(working_path)
      new(Bananajour.repositories_path / (working_path.expand_path.split.last.to_s + ".git"))
    end
    def initialize(path)
      @path = Fancypath(path)
    end
    attr_reader :path
    def exists?
      path.exists?
    end
    def init!
      path.create_dir
      Dir.chdir(path) do
        `git-init --bare`
      end
    end
    def name
      dirname.sub(".git",'')
    end
    def dirname
      path.split.last.to_s
    end
    def to_s
      name
    end
    def uri
      Bananajour.git_uri + dirname
    end
    def grit_repo
      Grit::Repo.new(path)
    end
    def destroy!
      path.remove
    end
    def readme
      grit_repo.tree.contents.find {|c| c.name =~ /Readme/i }
    end
    def advertise!
      tr = DNSSD::TextRecord.new
      tr["uri"] = uri
      tr["bjour-name"] = Bananajour.config.name
      tr["bjour-uri"] = Bananajour.web_uri
      DNSSD.register(name, "_git._tcp", nil, 9418, tr) {}
    end
  end
end
