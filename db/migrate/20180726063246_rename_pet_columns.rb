class RenamePetColumns < ActiveRecord::Migration[5.2]
  def change
    change_table :pets do |t|
      t.rename :description1, :description
      t.rename :adoptionCost, :adoption_cost
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
