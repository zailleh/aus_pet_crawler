# == Schema Information
#
# Table name: pets
#
#  id                  :bigint(8)        not null, primary key
#  pet_id              :bigint(8)
#  api_id              :bigint(8)
#  adoption_cost       :float
#  description         :text
#  date_of_birth       :date
#  breed_primary       :text
#  breed_secondary     :text
#  desexed             :boolean
#  primary_colour      :string
#  secondary_colour    :string
#  name                :text
#  behaviour_evaluated :boolean
#  health_checked      :boolean
#  vaccinated          :boolean
#  wormed              :boolean
#  special_needs_ok    :boolean
#  long_term_resident  :boolean
#  senior              :boolean
#  microchipped        :boolean
#  shelter             :bigint(8)
#  sex                 :string
#  size                :string
#  state               :string
#  animal_status       :string
#  animal_type         :bigint(8)
#  public_url          :text
#  active              :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type_name           :string
#

class Pet < ApplicationRecord
  has_many :photos

  # validate presence
  validates :name, 
            :api_id, 
            :pet_id,
            :description,
            :date_of_birth,
            :breed_primary,
            :desexed,
            :primary_colour,
            :behaviour_evaluated,
            :health_checked,
            :vaccinated,
            :wormed,
            :special_needs_ok,
            :long_term_resident,
            :senior,
            :microchipped,
            :shelter,
            :sex,
            :size,
            :state,
            :animal_status,
            :animal_type,
            :public_url,
            :active,
            :type_name,
            presence: true
  
  validates :size, inclusion: { in: ['Small', 'Medium', 'Large', 'Extra Large', 'Unknown']} 
  validates :animal_status, inclusion: { in: ['Looking','Trial','Fostered','Adopted']}

  validates :sex, inclusion: { in: %w(Male Female) }
end
