# == Schema Information
#
# Table name: sites
#
#  id            :bigint(8)        not null, primary key
#  url           :text
#  last_scan     :datetime         default(Wed, 18 Jul 2018 04:04:18 UTC +00:00)
#  next_scan     :datetime         default(Wed, 18 Jul 2018 04:04:18 UTC +00:00)
#  scan_interval :integer          default(1440)
#

class Site < ApplicationRecord
  
end
