require_relative '../rails_helper'

describe 'Scraper' do
  let :scraper do
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    driver = Selenium::WebDriver.for(:chrome, options: options)
    
    Scraper.new driver
  end

  describe "class" do
    it "is Scraper" do
     expect(scraper.class).to be Scraper
    end
  end

  describe "scraper" do
    it "gets a page" do
      scraper.scrape 'http://www.google.com.au'
      expect(scraper.current_url).to eq 'https://www.google.com.au/?gws_rd=ssl'
    end

    it "updates database for page if it exists" do
      test = scraper.scrape 'https://www.adoptapet.com.au/'
      expect(test).to eq true
    end
    it "doesn't update database for page if it doesn't exist" do
      test = scraper.scrape 'http://www.google.com.au'
      expect(test).to eq false
    end
  end
end