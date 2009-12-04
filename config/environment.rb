RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)


ENV["mode"] ||= (ARGV[0] || "development")
ENV["logger"] ||= "quiet"

puts "Starting in #{ENV["mode"]} mode."

require "rubygems"
require 'yaml'
require 'aws/s3'
require "activesupport"

