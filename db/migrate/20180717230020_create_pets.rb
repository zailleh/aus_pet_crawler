class CreatePets < ActiveRecord::Migration[5.2]
  def change
    create_table :pets do |t|
      t.bigint :pet_id
      t.bigint :api_id
      t.bigint :shelterBuddyId
      t.float :adoptionCost
      t.text :description1
      t.text :description2
      t.date :date_of_birth
      t.string :readable_age
      t.integer :ageMonths
      t.integer :ageYears
      t.boolean :isCrossBreed
      t.text :breedPrimary
      t.text :breedSecondary
      t.boolean :isDesexed
      t.string :primary_colour
      t.string :secondary_colour
      t.text :colour_url
      t.bigint :breeder_id
      t.text :name
      t.boolean :hadBehaviourEvaluated
      t.boolean :hadHealthChecked
      t.boolean :isVaccinated
      t.boolean :isWormed
      t.boolean :isSpecialNeedsOkay
      t.boolean :isLongtermResident
      t.boolean :isSeniorPet
      t.boolean :isMicrochipped
      t.bigint :shelter
      t.string :sex
      t.string :size
      t.text :youTubeVideo
      t.string :state
      t.bigint :animal_status
      t.bigint :animal_type
      t.text :public_url
      t.boolean :isActive

      t.timestamps
    end
  end
end
