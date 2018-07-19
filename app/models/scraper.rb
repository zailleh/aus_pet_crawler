class Scraper

  def scrape(url)
    s = Site.find_by url: url 
    
    if s.present?
      s.last_scraped = DateTime::now
      s.save
    end
  end

end
