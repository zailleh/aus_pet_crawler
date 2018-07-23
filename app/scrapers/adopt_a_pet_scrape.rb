class AdoptAPetScrape < Scraper

  def initialize(browser)
    @browser = browser
  end
  def scrape_js_pets(b) #b for browser
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
            url = "https://www.adoptapet.com.au/pet/#{ p.api_id }"
            Site.create url: url
          rescue
            puts "#{url} is already in the database"
          end
        end
      rescue
        puts "JavaScript failed, no animals_init"
      end
  end

  def scrape_html_pet_links(b)
    puts "doing pet links"
    anchors = b.find_elements(css: 'div.pet a')
    puts "found #{anchors.count} links"
    anchors.each do |a|
      begin
        puts "adding #{a[:href]}"
        Site.create url: a[:href] if a[:href].start_with? 'https://www.adoptapet.com.au/'
      rescue
        puts "#{a[:href]} is already in the database"
      end
    end
  end

  def scrape_locations(b)
    locations = b.find_elements(css: '#location > option')
    locations.each do |shelter|
      
      shelter_id = shelter[:value]
      
      s = Shelter.find_or_initialize_by :shelter_id => shelter_id
      unless s.id.present? || s.name.present? || s.state.present?
        s.state = shelter.attribute("data-state")
        s.name = shelter.text
        s.save
      end
    end

    return nil
  end

  def extract_pet_info(b)
    info = b.find_elements(css: '#pet-info > p.category')
    description = b.find_elements(css: '#about-pet:nth-of-type(2) > div')[0]
    description = description.text.remove description.find_elements(css: 'h2')[0].text if description.present?

    pet_info = {}
    pet_info['description1'] = description

    info.each do |inf|
      attribute = inf.find_elements(css: 'b')[0].text 
      value = inf.text.remove attribute
      pet_info[attribute.downcase.remove ": ", ":"] = value
    end

    pet_info
  end

  def extract_shelter_info(b)
    shelter = b.find_elements(css: '#contact-pet > p')
    shelter_data = {}
    shelter.each_with_index do |detail,i|
      unless detail.text.empty?
        #extract attribute name from the bold portion of the paragraph
        begin #We're going to catch if there's no b tag found since it'll be an empty P
          attribute_name = detail.find_elements(css: 'b')[0].text
          attribute = attribute_name.downcase.remove ": ", ":"
          # special instructions for address
          puts "attribute_name: #{attribute_name}"
          puts "attribute: #{attribute}"

          if attribute == 'address'
            value = b.find_elements(css: '#contact-pet > p:not([class])')[0].text
          elsif attribute == 'adoptions'
            value = b.find_elements(css: "#contact-pet > p:nth-child(#{i+4})")[0].text
          else  
            value = detail.text.remove attribute_name
          end
          
          shelter_data[attribute] = value
        rescue
          puts "no b tag found"
        end
      end
    end

    shelter_data
  end

  def scrape_html_pet_data(b)
    # if the pet-info is not there, we're not on a pet page, so don't try.
    unless b.find_elements(css: '#pet-info > p.category').empty?
      active_image = b.find_elements(css: '#pet-picture > div > div.swiper-container.gallery-top.swiper-container-horizontal > div > div.swiper-slide.swiper-slide-active > img')[0]

      images = b.find_elements(css: '#pet-picture > div > div.swiper-container.gallery-thumbs.swiper-container-horizontal > div > div.swiper-slide > img')

      pet_info = extract_pet_info b
      shelter_info = extract_shelter_info b

      # create shelter
      s = Shelter.find_or_initialize_by :name => shelter_info['location']
      s.phone = shelter_info['phone']
      s.details = shelter_info['adoptions']
      s.address = shelter_info['address']
      s.save

      # create pet
      p = Pet.find_or_initialize_by :api_id => b.current_url.split("/").last.to_i
      p.name = pet_info['name'] #checked
      p.type_name = pet_info['type'] #c
      p.breedPrimary = pet_info['breed'].split(' / ')[0] #
      p.breedSecondary = pet_info['breed'].split(' / ')[1] #

      p.sex = pet_info['sex'] #
      p.size = pet_info['size'] #
      p.primary_colour = pet_info['colour'].split(' / ')[0] #
      p.secondary_colour = pet_info['colour'].split(' / ')[1] #

      #18 years and 7 months => ["18","7"]
      age_parts = pet_info['age'].scan(/\d{1,2}/)
      dob = Date::today - age_parts[0].to_i.years - age_parts[1].to_i.months
      p.date_of_birth = dob

      p.description1 = pet_info['description1']

      p.shelter = s.shelter_id
      if p.save
        # create images
        # active image first
        p.photos.find_or_create_by :image_path => active_image['src']
        # and additional images
        images.each do |pic|
          p.photos.find_or_create_by :image_path => pic['src']
        end
      end
      images
    end
  end

  
  def scrape(browser)
    super browser.current_url
        
    scrape_js_pets browser
    
    if Shelter.last.present? && Shelter.last.updated_at < (Date::today - 1.day)
      scrape_locations browser
    elsif Shelter.last.nil?
      scrape_locations browser
    end
    
    scrape_html_pet_data browser

    scrape_html_pet_links browser
  end

end