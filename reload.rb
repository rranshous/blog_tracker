require './client.rb'
require 'json'

c = BlogTracker::Client.new 'http://blog-tracker.slag.local'

JSON.load(File.read('/home/robby/hrefs.json')).each do |domain, data|
  puts ['domain','source','type'].map{|i|puts "#{i} :: #{data[i]}" }
  puts c.add data['domain'], data['source'], data['type']
  puts
end
