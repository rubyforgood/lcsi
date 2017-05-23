require 'rails_helper'
RSpec.describe Problem, type: :model do
  describe "#uploaded_files_dir" do
    let(:problem) do
      Problem.create!({
        contest: Contest.instance
      })
    end

    it 'includes the record id' do
      expect(problem.uploaded_files_dir.to_s).to include(problem.id.to_s)
    end
  end

  it "has many submissions" do
    contest = Contest.instance
    problem = Problem.create!(contest: contest)
    account = Account.create!(contest: contest)
    problem.submissions.create!(account: account)
    problem.submissions.create!(account: account)
    expect(problem.submissions.count).to be 2
  end

end

# == Schema Information
#
# Table name: problems
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  contest_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  timeout         :integer
#  has_input       :boolean
#  auto_judge      :boolean
#  ignore_case     :boolean
#  whitespace_rule :string           default("plain diff")
#
