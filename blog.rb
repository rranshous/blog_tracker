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
    }, @@solecist_views.last, { source: source }
  end
  def self.get_domain_details domain
    @@soleclient.get domain
  end
  def self.to_href domain
    "http://#{domain}/"
  end
end

