class Remove < ActiveRecord::Migration[5.2]
  def change
    remove_column :pets, :animal_type
  end
end
