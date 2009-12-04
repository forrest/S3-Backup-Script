#!/usr/bin/env ruby
require(File.join(File.dirname(__FILE__), 'config', 'environment.rb'))

#open connection to s3
s3_conf = YAML.load_file('config/s3_keys.yml')[ENV["mode"]].symbolize_keys
conn = AWS::S3::Base.establish_connection!(:access_key_id => s3_conf[:access_key_id], :secret_access_key => s3_conf[:secret_access_key])
if not conn
  puts "failed to connect to s3"
  return
end

#make folder
archive_folder = File.join(RAILS_ROOT, "..", "archive")
folder_name = Time.now.to_i.to_s
folder_path = File.join(archive_folder, folder_name)
Dir.mkdir(folder_path)


#download each file
puts "listing up the #{ENV['name']} bucket"
entries = AWS::S3::Bucket.find(s3_conf[:bucket_name]).entries

if entries.empty?
  puts "Empty"
  return
else
  puts "Backing up #{entries.length} files"
end

start_time = Time.now
entries.each do |entry|
  File.open(File.join(folder_path, entry.key), "w+"){|file|
    file << entry.value
  }
end
end_time = Time.now

puts " - finished in #{end_time-start_time} seconds"