require 'rails_helper'

RSpec.describe Contest, type: :model do
  it "has many problems" do
    contest = Contest.instance
    contest.problems.create
    contest.problems.create
    expect(contest.problems.count).to be 2
  end

  it "has many accounts" do
    contest = Contest.instance
    contest.accounts.create
    contest.accounts.create
    expect(contest.accounts.count).to be 3
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
