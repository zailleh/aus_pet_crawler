class CrawlJob < ApplicationJob
  queue_as :default

  def get_browser
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    driver = Selenium::WebDriver.for(:chrome, options: options)
    driver
  end

  def fetch_url(browser, url)
    browser.get url
    sleep 10
  end

  def perform
    b = get_browser

    Site.where('next_scan <= ?', DateTime::now).each do |s|
      fetch_url b, s.url

      # Send entire browser through to scrape job after loading the URL
      scraper = AdoptAPetScrape.new b
      scraper.scrape
     
      s.last_scan = DateTime::now
      s.next_scan = DateTime::now + (s.scan_interval.minutes * (Random.rand - 0.5))
      s.save

      b.find_elements(css: 'a').each do |a|
        link = a[:href]
        
        begin
          unless !link.start_with?(s.url) || link.include?("#")
            Site.create url: link
          end
        rescue
          puts "#{a[:href]} is already in the database"
        end
      end
    end

    b.quit

    CrawlJob.set(wait: 1.hour).perform_later
  end
end