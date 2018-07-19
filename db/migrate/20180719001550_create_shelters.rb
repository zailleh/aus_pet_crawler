class CreateShelters < ActiveRecord::Migration[5.2]
  def change
    create_table :shelters do |t|
      t.bigint :shelter_id
      t.string :name
      t.string :state

      t.timestamps
    end
  end
end
