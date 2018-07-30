class ReworkPets < ActiveRecord::Migration[5.2]
  def change
    change_table :pets do |t|
      # t.remove :description, :name
      # t.string :part_number
      # t.index :part_number
      # t.rename :upccode, :upc_code
      t.remove :shelterBuddyId
      t.remove :description2
      t.remove :readable_age
      t.remove :ageMonths
      t.remove :isCrossBreed
      t.remove :ageYears
      t.remove :colour_url
      t.remove :breeder_id
      t.remove :youTubeVideo
      t.change :animal_status, :string
    end
  end
end
