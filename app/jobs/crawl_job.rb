class CrawlJob < ApplicationJob
  queue_as :default

  def get_browser
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    driver = Selenium::WebDriver.for(:chrome, options: options)
    driver
  end

  def perform
    b = get_browser

    Site.where('next_scan <= ?', DateTime::now).each do |s|
      AdoptAPetScrapeJob.perform_later s.url
      b.get(s.url)

      s.last_scan = DateTime::now
      s.next_scan = DateTime::now + s.scan_interval.minutes
      s.save

      b.find_elements(css: 'a').each do |a|
        begin
          Site.create url: a[:href] if a[:href].start_with? s.url
        rescue
          puts "#{a[:href]} is already in the database"
        end
      end
    end

    b.quit

    CrawlJob.set(wait: 1.hour).perform_later
    
  end
end