class RemoveStateFromPets < ActiveRecord::Migration[5.2]
  def change
    remove_column :pets, :state, :string
  end
end
