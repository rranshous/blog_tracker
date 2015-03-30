Gem::Specification.new do |s|
  s.name          = 'blogfinder'
  s.version       = '0.0.1'
  s.licenses      = ['BeerWare']
  s.summary       = "Simple client for simple data store"
  s.description   = "Simple client for simple data store"
  s.authors       = ["Robby Ranshous"]
  s.email         = "rranshous@gmail.com"
  s.files         = ["client.rb"]
  s.homepage      = "https://github.com/rranshous/blog_finder"
  s.require_paths = ['.']
  s.add_dependency 'httparty'
end

