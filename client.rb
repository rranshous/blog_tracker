require 'httparty'

module BlogTracker
  class Client
    include HTTParty
    def host
      ENV['BLOG_TRACKER_URL']
    end
    def add domain, source, type
      r = self.class.post("#{host}/blog/#{domain}", {
        body: { source: source, type: type } })
      r
    end
    def detail domain
      self.class.get("#{host}/blog/#{domain}").parsed_response
    end
    def all
      self.class.get("#{host}/blogs").parsed_response
    end
  end
end