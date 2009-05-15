require 'rubygems'
require "#{File.dirname(__FILE__)}/../lib/bananajour"

require 'sinatra'
require 'digest/md5'

disable :logging

load "#{File.dirname(__FILE__)}/lib/date_helpers.rb"
helpers DateHelpers

get "/" do
  @repositories = Bananajour.repositories
  haml :home
end

get "/:repository.git/discover" do
  hosts = []

  service = DNSSD.browse("_git._tcp") do |reply|
    DNSSD.resolve(reply.name, reply.type, reply.domain) do |rr|
      hosts << [reply.name, rr.text_record]
    end
  end

  sleep 5
  service.stop

  content_type "text/plain"
  hosts.inspect
end