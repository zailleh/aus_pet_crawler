class CrawlJob < ApplicationJob
  queue_as :default

  def get_browser
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])

    driver = Selenium::WebDriver.for(:chrome, options: options)
    driver
  end

  def perform
    b = get_browser

    Site.where('next_scan <= ?', DateTime::now).each do |s|
      b.get(s.url)

      begin
        animals = JSON.parse (b.execute_script( 'return init_animals == undefined? null : JSON.stringify(init_animals)'))
        
        if animals.present?
          animals.each do |a|

            a['type_name'] = a['type']['type_title']
            a['secondary_colour'] = a['secondary_colour']['colour']
            a['primary_colour'] = a['primary_colour']['colour']
            a['state'] = a['state']['name']
            
            a['size'] = a['size']['size']
            a['pet_id'] = a['id']

            photos = a['photo']
            a.delete 'photo'
            a.delete 'breedPrimaryId'
            a.delete 'breedSecondaryId'
            a.delete 'colourPrimaryId'
            a.delete 'colourSecondaryId'
            a.delete 'search_type_id'
            a.delete 'search_type'
            a.delete 'state_id'
            a.delete 'type'

            a.delete 'id'

            p = Pet.find_or_create_by :pet_id => a['pet_id']
            p.update a

            photos.each do |pic|
              pic.delete 'updated_at'
              pic.delete 'created_at'
              pic.delete 'id'
              pic['image_path'].prepend 'https://www.adoptapet.com.au'
              new_pic = p.photos.find_or_create_by :api_id => pic['api_id']
              new_pic.update pic
            end
          end

          begin
            url = "https://www.adoptapet.com.au/pet/#{ p.pet_id }"
            Site.create url: url
          rescue
            puts "#{url} is already in the database"
          end
        end
      rescue
        puts "JavaScript failed, no animals_init"
      end


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
  end
end