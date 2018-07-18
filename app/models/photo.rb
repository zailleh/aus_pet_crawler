# == Schema Information
#
# Table name: photos
#
#  id           :bigint(8)        not null, primary key
#  pet_id       :bigint(8)
#  animal_id    :bigint(8)
#  api_id       :bigint(8)
#  image_path   :text
#  api_path     :text
#  isDefault    :boolean
#  isActive     :boolean
#  isDownloaded :boolean
#

class Photo < ApplicationRecord
  belongs_to :pet
end
