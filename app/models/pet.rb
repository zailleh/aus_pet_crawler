# == Schema Information
#
# Table name: pets
#
#  id                    :bigint(8)        not null, primary key
#  pet_id                :bigint(8)
#  api_id                :bigint(8)
#  shelterBuddyId        :bigint(8)
#  adoptionCost          :float
#  description1          :text
#  description2          :text
#  date_of_birth         :date
#  readable_age          :string
#  ageMonths             :integer
#  ageYears              :integer
#  isCrossBreed          :boolean
#  breedPrimary          :text
#  breedSecondary        :text
#  isDesexed             :boolean
#  primary_colour        :string
#  secondary_colour      :string
#  colour_url            :text
#  breeder_id            :bigint(8)
#  name                  :text
#  hadBehaviourEvaluated :boolean
#  hadHealthChecked      :boolean
#  isVaccinated          :boolean
#  isWormed              :boolean
#  isSpecialNeedsOkay    :boolean
#  isLongtermResident    :boolean
#  isSeniorPet           :boolean
#  isMicrochipped        :boolean
#  shelter               :bigint(8)
#  sex                   :string
#  size                  :string
#  youTubeVideo          :text
#  state                 :string
#  animal_status         :bigint(8)
#  animal_type           :bigint(8)
#  public_url            :text
#  isActive              :boolean
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  type_name             :string
#

class Pet < ApplicationRecord
  has_many :photos
end
