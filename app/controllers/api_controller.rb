class ApiController < ApplicationController

  def pets
    pets = Pet.all
    render :plain => pets.to_json, content_type: "application/json"
  end

  def photos
    photos = Photo.where :pet_id => params[:id]
    render :plain => photos.to_json, content_type: "application/json"
  end

  def shelter
    shelter = Shelter.find_by :shelter_id => params[:id]
    render :plain => shelter.to_json, content_type: "application/json"
  end

end
