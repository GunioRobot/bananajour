gem 'mojombo-grit'
require 'grit'

module Bananajour
  class Repository
    def self.for_name(name)
      new(Bananajour.repositories_path.join(name + ".git"))
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
      Dir.chdir(path) { `git-init --bare` }
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
    def recent_commits_all_branches
      grit_repo.heads.collect do |head|
        grit_repo.commits(head.name).map do |commit|
          Struct.new(:commit, :branch).new(commit, head)
        end
      end.flatten.sort_by {|cb| cb.commit.committed_date}.reverse
    end
    def recent_unique_commits
      unique_commits = {}
      grit_repo.heads.each do |head|
        grit_repo.commits(head.name).each do |commit|
          unique_commits[commit.id] ||= Struct.new(:commit, :heads).new(commit, [])
          unique_commits[commit.id].heads << head
        end
      end
      unique_commits.to_a.map {|id, unique_commit| unique_commit}.sort_by {|uc| uc.commit.committed_date}.reverse
    end
    # def all_recent_commits
    #   commits_to_heads = {}
    # 
    #   grit_repo.heads.collect do |head|
    #     grit_repo.commits(head.name).map do |commit|
    #       commits[commit.id] ||= []
    #       commits[commit.id] << head
    #     end
    # 
    #   end.flatten
    #   
    #   
    #   Struct.new(:commit, :heads)
    #   
    # end
    def destroy!
      path.remove
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
