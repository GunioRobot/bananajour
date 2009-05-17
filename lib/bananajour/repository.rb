gem 'mojombo-grit', '1.1.1'
require 'grit'
require File.dirname(__FILE__) + "/../../sinatra/lib/date_helpers"

module Bananajour
  class Repository
    include DateHelpers
    
    def self.for_name(name)
      new(Bananajour.repositories_path.join(name + ".git"))
    end
    def self.html_friendly_name(name)
      name.gsub(/[^A-Za-z]+/, '').downcase
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
      Dir.chdir(path) { `git init --bare` }
    end
    def remove!
      path.rmtree
    end
    def name
      dirname.sub(".git",'')
    end
    def html_friendly_name
      self.class.html_friendly_name(name)
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
    def feed_uri
      Bananajour.web_uri + name + ".json"
    end
    def grit_repo
      @grit_repo ||= Grit::Repo.new(path)
    end
    def recent_commits
      @commits ||= grit_repo.commits(nil, 10)
    end
    def advertise!
      tr = DNSSD::TextRecord.new
      tr["uri"] = uri
      tr["name"] = name
      tr["bjour-name"] = Bananajour.config.name
      tr["bjour-uri"] = Bananajour.web_uri
      DNSSD.register(name, "_git._tcp", nil, 9418, tr) {}
    end
    def readme_file
      grit_repo.tree.contents.find {|c| c.name =~ /readme/i}
    end
    def rendered_readme
      case File.extname(readme_file.name)
      when /\.md/i, /\.markdown/i
        require 'rdiscount'
        RDiscount.new(readme_file.data).to_html
      when /\.textile/i
        require 'redcloth'
        RedCloth.new(readme_file.data).to_html(:textile)
      end
    rescue LoadError
      ""
    end
    def to_hash
      recent_commit_details = recent_commits.collect do|c|
        time_ago = time_ago_in_words(Time.parse(c.to_hash["committed_date"]))
        commit = c.to_hash.merge(
          "head" => c.head(grit_repo) && c.head(grit_repo).name,
          "committed_date_pretty" => time_ago.gsub("about ","") + " ago"
        )
        commit['author'].merge!({
         "gravatar" => c.author.gravatar_uri
        })
        commit
      end
      {
        "name" => name,
        "html_friendly_name" => html_friendly_name,
        "uri" => uri,
        "feed_uri" => feed_uri,
        "recent_commits" => recent_commit_details
      }
    end
  end
end