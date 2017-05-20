class Account < ApplicationRecord
  belongs_to :contest
  has_many :submissions

  def self.authenticate(username, token)
    Account.find_by(username: username, password: token)
  end
end
