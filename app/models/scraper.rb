class Scraper

  def initialize(browser)
    @browser = browser
  end

  def safeStrip(s)
    s.to_s.strip unless s.nil?
  end

  def get(url)
    @browser.get url
  end

  def current_url
    @browser.current_url
  end

  def scrape(url)
    s = Site.find_by( :url => url )
    
    if s.present?
      s.last_scraped = DateTime::now
      s.save
    else
      false
    end
  end

end
