class ScraperJob < ApplicationJob
  queue_as :default

  def get_browser
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    driver = Selenium::WebDriver.for(:chrome, options: options)
    driver
  end

  def load_page(browser, url)
    browser.get url
    puts "Sleeping 10 Seonds to allow JS to run"
    sleep 10
  end

  def perform(url)
    s = Site.find_by url: url 
    if s.present?
      s.last_scraped = DateTime::now
      s.save
    end
  end
end
