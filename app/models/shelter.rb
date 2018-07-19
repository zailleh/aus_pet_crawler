# == Schema Information
#
# Table name: shelters
#
#  id         :bigint(8)        not null, primary key
#  shelter_id :bigint(8)
#  name       :string
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Shelter < ApplicationRecord
end
