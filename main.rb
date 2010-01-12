#!/usr/bin/env ruby
require(File.join(File.dirname(__FILE__), 'config', 'environment.rb'))

#open connection to s3
s3_conf = YAML.load_file(RAILS_ROOT+'/config/s3_keys.yml')[ENV["mode"]].symbolize_keys
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
puts "listing up the #{s3_conf[:bucket_name]} bucket"
bucket = AWS::S3::Bucket.find(s3_conf[:bucket_name])

if bucket.size==0
  puts "Bucket is empty"
  return
else
  puts "Bucket contains atleast #{bucket.size()} files"
end

start_time = Time.now
marker = false
count = 0

while true
  new_object_list = bucket.objects(:max_keys => 100, :marker => (marker.key rescue "0"))
  break if new_object_list.empty?
  
  puts "loading next #{new_object_list.length} files : (#{marker.key rescue "No Marker"})"

  new_object_list.each do |entry|
    File.open(File.join(folder_path, entry.key), "w+"){|file|
      file << entry.value
    }
    count += 1
  end
  
  marker = new_object_list.last
  
  puts count
end

end_time = Time.now

puts " - finished #{count} files in #{end_time-start_time} seconds"