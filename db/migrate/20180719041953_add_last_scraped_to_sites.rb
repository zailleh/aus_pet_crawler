class AddLastScrapedToSites < ActiveRecord::Migration[5.2]
  def change
    add_column :sites, :last_scraped, :datetime
  end
end
