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
#  animal_status       :string
#  public_url          :text
#  active              :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type_name           :string
#

class Pet < ApplicationRecord
  has_many :photos
  after_initialize :defaults, unless: :persisted?
              # ":if => :new_record?" is equivalent in this context

  def defaults
    self.behaviour_evaluated = false if self.behaviour_evaluated.nil?
    self.special_needs_ok = false if self.special_needs_ok.nil?
    self.long_term_resident = false if self.long_term_resident.nil?
    self.senior = false if self.senior.nil?
  end

  # validate presence
  validates :name, 
            :api_id, 
            :pet_id,
            :description,
            :date_of_birth,
            :breed_primary,
            :desexed,
            :primary_colour,
            :vaccinated,
            :shelter,
            :sex,
            :size,
            :animal_status,
            :public_url,
            :active,
            :type_name,
            presence: true
  
  validates :size, inclusion: { in: ['Small', 'Medium', 'Large', 'Extra Large', 'Unknown']} 
  validates :animal_status, inclusion: { in: ['Looking','Trial','Fostered','Adopted']}

  validates :sex, inclusion: { in: %w(Male Female) }
end
