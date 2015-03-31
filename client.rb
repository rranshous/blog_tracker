require 'httparty'

module BlogTracker
  class Client
    include HTTParty
    def initialize host
      @host = host
    end
    def host
      @host || ENV['BLOG_TRACKER_URL']
    end
    def add domain, source, type
      r = self.class.post("#{host}/blog/#{domain}", {
        body: { source: source, type: type } })
      puts "R: #{r.code}"
      r.code == 200
    end
    def detail domain
      self.class.get("#{host}/blog/#{domain}").parsed_response
    end
    def all
      self.class.get("#{host}/blogs").parsed_response
    end
  end
end
