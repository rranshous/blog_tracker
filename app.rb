require 'sinatra'
require 'client' # solecist
require 'json'

class Blog
  @@soleclient = Solecist::Client.new ENV['SOLECIST_URL']
  # we are using domain as the key
  @@solecist_views = [
    {
      VERSION: 1,
      domain: :NEW,
      href: :NEW,
      created_at: :NEW,
      type: :NEW,
      source: :NEW
    }
  ]
  def self.get_domains
    @@soleclient.keys
  end
  def self.domain_exists? domain
    r = @@soleclient.get(domain)
    puts "DOMAIN EXISTS?: #{r}"
    r != nil
  end
  def self.add_domain domain, source, type
    now = Time.now.to_f
    @@soleclient.set domain, {
      domain: domain,
      href: to_href(domain),
      created_at: now,
      type: type,
      source: source
    }, @@solecist_views.last
  end
  def self.get_domain_details domain
    @@soleclient.get domain
  end
  def self.to_href domain
    "http://#{domain}/"
  end
end

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
