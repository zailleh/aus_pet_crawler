Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "api#pets"
  get '/pets' => "api#pets"
  get '/pets/:id' => "api#photos"
  get '/shelter/:id' => "api#shelter"
end
