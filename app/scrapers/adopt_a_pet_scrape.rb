class AdoptAPetScrape < Scraper

  def parse_status(status_id)
    # ['Looking','Trial','Fostered','Adopted']
    case status_id
    when nil then "Looking"
    when '3' then "Looking"
    end
  end

  def parse_pet_data(data)
    parsed_data = {
      name:                 data['name'],  #somestuff
      api_id:               data['api_id'],  #somestuff
      pet_id:               data['id'],  #somestuff
      description:          data['description1'],  #somestuff
      date_of_birth:        data['date_of_birth'],  #somestuff
      breed_primary:        data['breedPrimary'],  #somestuff
      desexed:              data['isDesexed'],  #somestuff
      primary_colour:       data['primary_colour']['colour'],  #somestuff
      behaviour_evaluated:  data['hadBehaviourEvalidated'],  #somestuff
      health_checked:       data['hadHealthChecked'],  #somestuff
      vaccinated:           data['isVaccinated'],  #somestuff
      wormed:               data['isWormed'],  #somestuff
      special_needs_ok:     data['isSpecialNeedsOkay'],  #somestuff
      long_term_resident:   data['isLongTermResident'],  #somestuff
      senior:               data['isSeniorPet'],  #somestuff
      microchipped:         data['isMicrochipped'],  #somestuff
      shelter:              data['shelter'],  #somestuff
      sex:                  data['sex'],  #somestuff
      size:                 data['size']['size'],  #somestuff
      animal_status:        parse_status( data['animal_status'] ),  #somestuff
      #animal_type:          data[],  #somestuff
      public_url:           data['public_url'],  #somestuff
      active:               data['isActive'],  #somestuff
      type_name:            data['type']['type_title']  #somestuff
    }
  end

  def scrape_js_pets
    begin
      animals = JSON.parse (@browser.execute_script( 'return init_animals == undefined? null : JSON.stringify(init_animals)'))
      
      if animals.present?
        animals.each do |a|
          new_pet = parse_pet_data a
          
          p = Pet.find_or_create_by :pet_id => new_pet[:pet_id]
          p.assign_attributes new_pet
          unless p.valid?
            p.errors.each {|k, v| puts "#{k.capitalize}: #{v}"}
          end
          
          p.save

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
      false
    end
  end

  def scrape_html_pet_links
    puts "doing pet links"
    anchors = @browser.find_elements(css: 'div.pet a')
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

  def scrape_locations
    locations = @browser.find_elements(css: '#location > option')
    locations.each do |shelter|
      
      shelter_id = shelter[:value]
      
      s = Shelter.find_or_initialize_by :shelter_id => shelter_id
      s.state = shelter.attribute("data-state")
      s.name = shelter.text
      s.save
      end
    end

    return nil
  end

  def get(url)
    super url
    sleep 10 #allow time for resources to load and JS to run
  end

  def extract_health_checks
    # <div class="col-xs-12">
    #   <h3><b>My stats</b></h3>
    #   <div class="row">
    #       <div class="col-xs-2 col-lg-1"><i class="fa fa-check"></i></div>
    #       <div class="col-xs-10 col-lg-10">
    #           <p>My health has been checked</p>
    #       </div>
    #   </div>
    #   <div class="row">
    #       <div class="col-xs-2 col-lg-1"><i class="fa fa-check"></i></div>
    #       <div class="col-xs-10 col-lg-10">
    #           <p>My vaccinations are up-to-date</p>
    #       </div>
    #   </div>
    #   <div class="row">
    #       <div class="col-xs-2 col-lg-1"><i class="fa fa-check"></i></div>
    #       <div class="col-xs-10 col-lg-10">
    #           <p>My worming is up-to-date</p>
    #       </div>
    #   </div>
    #   <div class="row">
    #       <div class="col-xs-2 col-lg-1"><i class="fa fa-check"></i></div>
    #       <div class="col-xs-10 col-lg-10">
    #           <p>I have been microchipped</p>
    #       </div>
    #   </div>
    #   <div class="row">
    #       <div class="col-xs-2 col-lg-1"><i class="fa fa-check"></i></div>
    #       <div class="col-xs-10 col-lg-10">
    #           <p>I am desexed</p>
    #       </div>
    #   </div>
    # </div>
    healthchecks = @browser.find_elements(css: '#stats > div > div.row')
    checksdata = {}
    healthchecks.each do |h|
      item = h.find_elements(css: 'p')
      item = !item.nil? ? item[0].text.downcase : nil
      
      case 
      when item.include?('desex')
        checksdata[:desexed] = item.include? 'i am desexed'
      when item.include?('microchip')
        checksdata[:microchipped] = item.include? 'i have been microchipped'
      when item.include?('worm')
        checksdata[:wormed] = item.include? 'my worming is up-to-date'
      when item.include?('vaccin')
        checksdata[:vaccinated] = item.include? 'my vaccinations are up-to-date'
      when item.include?('health')
        checksdata[:health_checked] = item.include? 'my health has been checked'
      end
    end

    checksdata
  end

  def extract_pet_info( shelter_id )
    info = @browser.find_elements(css: '#pet-info > p.category')
    description = @browser.find_elements(css: '#about-pet:nth-of-type(2) > div')[0]
    description = description.text.remove description.find_elements(css: 'h2')[0].text if description.present?

    pet_info = {}
    
    pet_id = @browser.find_elements(css: '#pet-id > h3')[0]
    if pet_id.present?
      attribute = pet_id.find_elements(css: 'b')[0].text 
      value = pet_id.text.remove attribute
      pet_info['id'] = value
    else 
      pet_info['id']= -1;
    end

    health_data = extract_health_checks

    
    pet_info['description1'] = description

    info.each do |inf|
      attribute = inf.find_elements(css: 'b')[0].text 
      value = inf.text.remove attribute
      pet_info[attribute.downcase.remove ": ", ":"] = value
    end

    pet_info['type'] = { 'type_title' => pet_info['type'] }
    pet_info['breedPrimary'] = pet_info['breed'].split(' / ')[0]
    pet_info['breedSecondary'] = pet_info['breed'].split(' / ')[1]

    pet_info['sex'] = pet_info['sex'].strip.capitalize #
    pet_info['size'] = { 'size' => pet_info['size'].strip.capitalize }

    # colours
    colours = pet_info['colour'].split(' / ')
    pet_info['primary_colour'] = { 'colour' => colours[0] }
    pet_info['secondary_colour'] = { 'colour' => colours[1] }
    pet_info['shelter'] = shelter_id

    #18 years and 7 months => ["18","7"]
    age_parts = pet_info['age'].scan(/\d{1,2}/)
    dob = Date::today - age_parts[0].to_i.years - age_parts[1].to_i.months
    pet_info['date_of_birth'] = dob
    
    pet_info['api_id'] = @browser.current_url.split("/").last.to_i
    pet_info['isDesexed'] = health_data[:desexed]
    pet_info['isVaccinated'] = health_data[:vaccinated]
    pet_info['isMicrochipped'] = health_data[:microchipped]
    pet_info['hadHealthChecked'] = health_data[:health_checked]
    pet_info['isWormed'] = health_data[:wormed]
    pet_info['public_url'] = @browser.current_url
    pet_info['isActive'] = @browser.find_elements(css: '.unavailable-container')[0].nil?

    pet_info
  end

  def extract_shelter_info
    shelter = @browser.find_elements(css: '#contact-pet > p')
    shelter_data = {}
    shelter.each_with_index do |detail,i|
      unless detail.text.empty?
        #extract attribute name from the bold portion of the paragraph
        begin #We're going to catch if there's no b tag found since it'll be an empty P
          attribute_name = detail.find_elements(css: 'b')[0].text
          attribute = attribute_name.downcase.remove ": ", ":"
          # special instructions for address

          if attribute == 'address'
            value = @browser.find_elements(css: '#contact-pet > p:not([class])')[0].text
          elsif attribute == 'adoptions'
            value = @browser.find_elements(css: "#contact-pet > p:nth-child(#{i+4})")[0].text
          else  
            value = detail.text.remove attribute_name
          end
          
          shelter_data[attribute] = value
        rescue
          # puts "no b tag found"
        end
      end
    end

    s = Shelter.find_or_initialize_by :name => shelter_data['location']
    s.phone = shelter_data['phone']
    s.details = shelter_data['adoptions']
    s.address = shelter_data['address']

    return s
  end

  def scrape_html_pet_data
    # if the pet-info is not there, we're not on a pet page, so don't try.
    unless @browser.find_elements(css: '#pet-info > p.category').empty?
      active_image = @browser.find_elements(css: '#pet-picture > div > div.swiper-container.gallery-top.swiper-container-horizontal > div > div.swiper-slide.swiper-slide-active > img')[0]

      images = @browser.find_elements(css: '#pet-picture > div > div.swiper-container.gallery-thumbs.swiper-container-horizontal > div > div.swiper-slide > img')

      # create shelter first as pet must have a shelter
      shelter = extract_shelter_info
      shelter.save

      #get pet info
      pet_info = extract_pet_info shelter.id

      # create pet
      p = Pet.find_or_initialize_by api_id: pet_info['api_id']

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

  
  def scrape
    super @browser.current_url
        
    scrape_js_pets
    
    if Shelter.last.present? && Shelter.last.updated_at < (Date::today - 1.day)
      scrape_locations
    elsif Shelter.last.nil?
      scrape_locations
    end
    
    scrape_html_pet_data

    scrape_html_pet_links
  end

end