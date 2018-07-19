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
  end

  def perform(url)
    
  end
end
