require_relative '../rails_helper'

describe 'AdoptAPetScraper' do
  let :scraper do
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    options.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    driver = Selenium::WebDriver.for(:chrome, options: options)
    
    AdoptAPetScrape.new driver
  end

  describe "class" do
    it "is an Adopt A Pet Scraper" do
     expect(scraper.class).to be AdoptAPetScrape
    end

    it "superclass is 'Scraper'" do
      expect(AdoptAPetScrape.superclass).to be Scraper
    end
  end

  describe "scrapes" do
    it "gets pets on homepage from js" do

    end
  end

end