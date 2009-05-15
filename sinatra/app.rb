require 'rubygems'
require "#{File.dirname(__FILE__)}/../lib/bananajour"

gem 'sinatra', '0.9.1.1'
require 'sinatra'

gem 'json', '1.1.2'
require 'json'

require 'digest/md5'

disable :logging
set :environment, :production

load "#{File.dirname(__FILE__)}/lib/date_helpers.rb"
helpers DateHelpers

get "/" do
  @repositories = Bananajour.repositories
  @network_repositories = Bananajour.network_repositories
  haml :home
end

get "/:repository/readme" do
  @repository = Bananajour::Repository.for_name(params[:repository])
  readme_file = @repository.readme_file
  @rendered_readme = @repository.rendered_readme
  @plain_readme = readme_file.data
  haml :readme
end

get "/index.json" do
  content_type "application/json"
  Bananajour.to_hash.to_json
end

get "/:repository.json" do
  content_type "application/json"
  Bananajour::Repository.for_name(params[:repository]).to_hash.to_json
end
