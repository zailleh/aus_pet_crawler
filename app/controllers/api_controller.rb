class ApiController < ApplicationController

  def pets
    pets = Pet.all
    render :plain => pets.to_json
  end
end
