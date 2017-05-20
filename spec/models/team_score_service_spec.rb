require 'rails_helper'

RSpec.describe TeamScoreService, type: :model do
  let(:contest) { Contest.create! }
  let(:team) { Team.create!(contest: contest) }

  describe '#call' do
    context 'without submissions' do
      it { expect(TeamScoreService.new(contest: contest, team: team).call).to eq(0) }
    end

    context 'with correct submissions' do
      it 'returns the number of correct submissions' do
        problem = Problem.create!(contest: contest)

        4.times { Submission.create!(problem: problem, team: team, status: 'passed') }

        expect(TeamScoreService.new(contest: contest, team: team).call).to eq(4)
      end
    end

    context 'with incorrect submissions' do
      it 'returns the number of correct submissions' do
        problem = Problem.create!(contest: contest)

        4.times {  Submission.create!(problem: problem, team: team, status: 'passed') }
        4.times {  Submission.create!(problem: problem, team: team, status: 'failed') }

        expect(TeamScoreService.new(contest: contest, team: team).call).to eq(4)
      end
    end

    context 'with multiple contests' do
      it 'returns the score for a specific contest' do
        other_contest = Contest.create!

        problem = Problem.create!(contest: contest)
        other_problem = Problem.create!(contest: other_contest)

        4.times {  Submission.create!(problem: problem, team: team, status: 'passed') }
        4.times {  Submission.create!(problem: other_problem, team: team, status: 'failed') }

        expect(TeamScoreService.new(contest: contest, team: team).call).to eq(4)
      end
    end
  end
end
