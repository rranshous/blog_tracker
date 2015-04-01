require 'sinatra'
require 'client' # solecist
require 'json'
require_relative 'blog'

get '/blogs' do
  content_type :json
  domains = Blog.get_domains
  etag domains.length
  domains.to_json
end

get '/blogs.txt' do
  content_type :text
  domains = Blog.get_domains
  etag domains.length
  domains.join("\n")
end

get '/hrefs.txt' do
  content_type :text
  domains = Blog.get_domains
  etag domains.length
  domains.map { |d| to_href(d) }.join("\n")
end

get '/blog/:domain' do |domain|
  content_type :json
  Blog.get_domain_details(domain).to_json
end

post '/blog/:domain' do |domain|
  source = params[:source]
  type = params[:type]
  if Blog.domain_exists? domain
    puts "Domain exists"
    halt 409
  end
  Blog.add_domain domain, source, type
  puts "added: #{domain}"
end
