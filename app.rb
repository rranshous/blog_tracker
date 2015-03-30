require 'sinatra'
require 'redis'
require 'json'


$redis_client = Redis.new

get '/blog' do
  content_type :json
  $redis_client.smembers('blogs').to_json
end

post '/blog/:domain' do |domain|
  puts "Adding #{domain}"
  if $redis_client.sadd('blogs', domain)
    puts "added: #{domain}"
  end
end
