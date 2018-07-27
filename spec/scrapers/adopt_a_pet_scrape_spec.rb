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

  describe "parses" do
    it "Adopt A Pet JS data" do
      data = JSON.parse '{"id":"40358","api_id":"548310","shelterBuddyId":"393443","adoptionCost":"0.00","description1":"Hi my name is Benny,I came into care with my sister as young kittens, we were quiet scared of people but over time have gotten a lot more confidence. My sister has been adopted but I am still waiting.I am still a little bit shy, I do enjoy sleeping on my foster mums bed and love to play and pouch when I see a foot move! I can also be pretty affectionate and rub around their legs when I feel comfortable. Sometimes I get frightened of certain situations or noises and go and hide where I feel safe. I get along well with other cats but would suit a home where there is no dogs or small children.I will need time to adjust to my new surroundings and new family and you will have to spend time gaining my trust and showing me that you are safe and make me feel comfortable but once you get me there we will be friends for life. My adoption fee is $170 which includes: Desexing, microchip, up to date vaccinations, worm/flea treatment and a vet health check.Could I be the puppy for you? Cant wait to hear from you!","description2":"","date_of_birth":"2016-01-07T14:00:00Z","readable_age":"2 years and 6 months","ageMonths":"6","ageYears":"2","isCrossBreed":"1","breedPrimaryId":"33","breedPrimary":"Domestic Short Hair","breedSecondaryId":"0","breedSecondary":"","isDesexed":"1","colourPrimaryId":"231","colourSecondaryId":"248","colour_url":"/api/v1/animalColours?animalId=548310","breeder_id":null,"name":"Benny","hadBehaviourEvaluated":"0","hadHealthChecked":"1","isVaccinated":"1","isWormed":"1","isSpecialNeedsOkay":"0","isLongtermResident":"0","isSeniorPet":"0","isMicrochipped":"1","shelter":"63","search_type_id":"4","search_type":"","sex":"Male","size":{"id":"3","api_id":"3","size":"Medium","isActive":"1","created_at":"2018-07-27 00:00:02","updated_at":"2018-07-27 00:00:02"},"youTubeVideo":"","state_id":"2","animal_status":"3","animal_type":"2","public_url":"https://api.adoptapet.com.au:443/animal/animalDetails.asp?searchType=4&animalId=548310","isActive":"1","created_at":"2017-04-08 21:30:04","updated_at":"2018-07-27 00:09:40","photo":[{"id":"74314715","animal_id":"548310","api_id":"4276252","image_path":"/img/animals/4276252.jpg","api_path":"/photos/lostfound/548310.jpg","isDefault":"1","isActive":"1","isDownloaded":"1","created_at":"2018-07-27 02:00:17","updated_at":"2018-07-27 02:00:17"},{"id":"74314714","animal_id":"548310","api_id":"4276251","image_path":"/img/animals/4276251.jpg","api_path":"/photos/lostfound/e6b31236-d383-4874-a1ef-51297958ada2.jpg","isDefault":"0","isActive":"1","isDownloaded":"1","created_at":"2018-07-27 02:00:17","updated_at":"2018-07-27 02:00:17"},{"id":"74314716","animal_id":"548310","api_id":"4276253","image_path":"/img/animals/4276253.jpg","api_path":"/photos/lostfound/dfa1f110-89ef-47a2-8243-6d0aa3c710bb.jpg","isDefault":"0","isActive":"1","isDownloaded":"1","created_at":"2018-07-27 02:00:17","updated_at":"2018-07-27 02:00:17"}],"state":{"id":"2","api_id":"2","name":"NSW","donate_url":"https://www.rspcansw.org.au/donate-to-rspca","isActive":"1","created_at":"2018-07-27 00:00:06","updated_at":"2018-07-27 00:00:06"},"primary_colour":{"id":"231","api_id":"231","colour":"Tabby","isActive":"1","created_at":"2018-07-27 00:00:03","updated_at":"2018-07-27 00:00:03"},"secondary_colour":{"id":"248","api_id":"248","colour":"White","isActive":"1","created_at":"2018-07-27 00:00:03","updated_at":"2018-07-27 00:00:03"},"type":{"id":"3","api_id":"2","type_title":"Cat","isActive":"1","created_at":"2018-07-27 00:00:02","updated_at":"2018-07-27 00:00:02"}}'
      p = Pet.new (scraper.parse_pet_data data)
      
      expect(p.valid?).to be true
    end

    it 'pet health info' do
      scraper.get 'https://www.adoptapet.com.au/pet/548310'
      data = scraper.extract_health_checks
      testData = {
        desexed: true,
        health_checked: true,
        vaccinated: true,
        wormed: true,
        microchipped: true
      }
      expect(data == testData).to be true
    end

    it 'shelter data from pet page' do
      scraper.get 'https://www.adoptapet.com.au/pet/548310'
      s = scraper.extract_shelter_info      
      
      expect(s.valid?).to be true
    end

    it 'pet page data' do
      scraper.get 'https://www.adoptapet.com.au/pet/548310'
      s = scraper.extract_shelter_info 
      data = scraper.extract_pet_info(1)
      p = Pet.new (scraper.parse_pet_data data)
      p.valid?
      expect(p.errors.messages).to be {}
    end
  end

end