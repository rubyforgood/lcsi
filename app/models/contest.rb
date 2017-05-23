class Contest < ApplicationRecord
  has_many :problems
  has_many :accounts

  def self.instance
    order(:created_at).reverse.first
  end

  def start(time: Time.current.utc)
    self.started_at = time
  end
end

# == Schema Information
#
# Table name: contests
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  started_at :datetime
#
