class ApiController < ApplicationController

  def pets
    render :json => Pet.all
  end

  def photos
    render :json => Photo.where(:pet_id => params[:id])
  end

  def shelter
    render :json => Shelter.find_by(:shelter_id => params[:id])
  end

  def shelters
    render :json => Shelter.all
  end

end
