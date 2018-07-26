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
      t.remove :ageYears
      t.remove :isCrossBreed
      t.remove :colour_url
      t.remove :breeder_id
      t.remove :youTubeVideo
      t.change :animal_status, :string

      t.rename :adoptionCost, :adoption_cost
      t.rename :isCrossBreed, :cross_breed
      t.rename :breedPrimary, :breed_primary
      t.rename :breedSecondary, :breed_secondary
      t.rename :isDesexed, :desexed
      t.rename :hadBehaviourEvaluated, :behaviour_evaluated
      t.rename :hadHealthChecked, :health_checked
      t.rename :isVaccinated, :vaccinated
      t.rename :isWormed, :wormed
      t.rename :isSpecialNeedsOkay, :special_needs_ok
      t.rename :isLongtermResident, :long_term_resident
      t.rename :isSeniorPet, :senior
      t.rename :isMicrochipped, :microchipped
      t.rename :isActive, :active
    end
  end
end
