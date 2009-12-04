RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)

ENV["mode"] ||= "development"
ENV["logger"] ||= "quiet"

require "rubygems"
require 'yaml'
require 'aws/s3'
require "activesupport"

