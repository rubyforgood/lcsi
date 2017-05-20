require 'rails_helper'

RSpec.describe TeamTimeService, type: :model do
  let(:contest) { Contest.create!(started_at: Time.now) }
  let(:team) { Team.create!(contest: contest) }

  describe '#call' do
    context 'without submissions' do
      it { expect(TeamTimeService.new(contest: contest, team: team).call).to eq(Float::INFINITY) }
    end

    context 'with failed submissions' do
      it 'penalizes failed submissions' do
        problem = Problem.create!(contest: contest)
        Submission.create!(problem: problem, team: team, status: 'failed')

        expect(TeamTimeService.new(contest: contest, team: team).call)
          .to be >= Rails.configuration.failed_submission_time_penalty
      end
    end

    context 'with passed submission' do
      it 'returns the difference between submission time and contest start time' do
        problem = Problem.create!(contest: contest)
        submission = Submission.create!(problem: problem, team: team, status: 'passed')

        expected_time = submission.created_at - contest.started_at
        expect(TeamTimeService.new(contest: contest, team: team).call).to eq(expected_time)
      end
    end
  end
end
