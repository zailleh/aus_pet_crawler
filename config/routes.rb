Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "api#pets"
  get '/pets' => "api#pets", defaults: { format: :json }
  get '/pets/:id' => "api#photos", defaults: { format: :json }
  get '/shelters' => "api#shelters", defaults: { format: :json }
  get '/shelters/:id' => "api#shelter", defaults: { format: :json }
end
