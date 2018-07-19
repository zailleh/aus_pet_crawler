class AddDetailsToShelter < ActiveRecord::Migration[5.2]
  def change
     add_column :shelters, :address, :string
     add_column :shelters, :phone, :string
     add_column :shelters, :details, :text
  end
end
