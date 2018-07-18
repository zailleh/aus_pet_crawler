# :smile_cat: Australian Pet Adoption API
:dog2:**Mission:** to be an API that contains pets for adoption from all over Australia

Use the API at: https://au-pet-api.herokuapp.com/

## :rabbit: How to use the API
Firsly, the API returns `application/json` data only. The root for the API returns a list of *all pets*. You can parse this data into an object in the language of your choice.

### :dog: API URLS
* `.../` returns all pets
* `.../pets/` returns all pets
* `.../pets/:id` returns urls for pictures for the pet `:id`

#### Features to add: 
* `.../pets/:type` to return pets of type `:type`, eg 'cat'
* `.../pets/:state` to return pets in a given `:state`, eg 'NSW'
* `.../pets/search?s=:state&t=:type...` search url to return pets matching given criteria

## Technical Information
This API is run using:
* Ruby 2.5.1
* Rails 5.2.0
* Postgresql 10.4

### Dependencies
* [chromedriver](http://chromedriver.chromium.org/) ( install with `brew cask install chromedriver` )

#### Buildpacks for Heroku:
Heroku requires the [chromedriver](https://github.com/heroku/heroku-buildpack-google-chrome) and [google-chrome](https://github.com/heroku/heroku-buildpack-chromedriver) buildpacks to run the scraper portion of the API:
``` bash
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-google-chrome
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-chromedriver
```

### Database Setup
As mentioned above, the database in use is PostgreSQL. After cloning the repo, assuming you have PostgreSQL already running, simply run the below:
```
rails db:create && rails db:migrate && rails db:seed
```

### Services 
This API currently uses a single `ActiveJob` to gather data, called `CrawlJob`. This job will run automatically  1 minute after startup and every hour thereafter.

To run the job manually, in the Rails concole, run:
```
CrawlJob.perform_now
```
This job should be further simplified and broken down as more sites and crawlers are added.