require 'sinatra'
require 'redis'
require 'json'

$redis = Redis.new

helpers do
  def redis_key domain
    "blogs:#{domain}"
  end
  def get_domains
    $redis.smembers('blogs')
  end
  def domain_exists? domain
    $redis.exists redis_key(domain)
  end
  def add_domain domain, source, type
    key = redis_key domain
    now = Time.now.to_f.to_s
    $redis.watch domain
    $redis.multi do
      $redis.sadd('blogs', domain)
      $redis.hset(key, 'domain', domain)
      $redis.hset(key, 'created', now)
      $redis.hset(key, 'source', source) if source
      $redis.hset(key, 'type', type) if type
    end
  end
  def get_domain_details domain
    $redis.hgetall redis_key(domain)
  end
  def to_href domain
    "http://#{domain}/"
  end
end

get '/blogs' do
  content_type :json
  domains = get_domains
  etag domains.length
  domains.to_json
end

get '/blogs.txt' do
  content_type :text
  domains = get_domains
  etag domains.length
  domains.join("\n")
end

get '/hrefs.txt' do
  content_type :text
  domains = get_domains
  etag domains.length
  domains.map { |d| to_href(d) }.join("\n")
end

get '/blog/:domain' do |domain|
  content_type :json
  get_domain_details(domain).to_json
end

post '/blog/:domain' do |domain|
  source = params[:source]
  type = params[:type]
  halt 409 if domain_exists? domain
  add_domain domain, source, type
  puts "added: #{domain}"
end
