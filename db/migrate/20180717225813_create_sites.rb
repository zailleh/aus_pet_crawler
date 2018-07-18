class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.text :url
      t.datetime :last_scan, :default => DateTime.now
      t.datetime :next_scan, :default => DateTime.now
      t.integer :scan_interval, :default => '1440' #minutes   
    end
    add_index :sites, :last_scan
    add_index :sites, :next_scan
  end
end
