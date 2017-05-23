require 'rails_helper'

RSpec.describe TeamTimeService, type: :model do
  let(:contest) { Contest.instance }
  let(:account) { Account.create!(contest: contest) }

  before do
    contest.start
    contest.save!
  end

  describe '#call' do
    context 'without submissions' do
      it { expect(TeamTimeService.new(contest: contest).call(account: account)).to eq(0) }
    end

    context 'with failed submission' do
      context 'without passed submission' do
        it 'does not penalize failed submissions' do
          problem = Problem.create!(contest: contest)
          Submission.create!(problem: problem, account: account, status: 'failed')

          expect(TeamTimeService.new(contest: contest).call(account: account)).to eq(0)
        end
      end
    end

    context 'with passed submission' do
      it 'returns the difference between submission time and contest start time' do
        problem = Problem.create!(contest: contest)
        submission = Submission.create!(problem: problem, account: account, status: 'passed')

        submission.reload

        expected_time = submission.created_at - contest.started_at
        expect(TeamTimeService.new(contest: contest).call(account: account)).to eq(expected_time)
      end
    end

    context 'with multiple submissions' do
      it 'sums the submission times' do
        problem = Problem.create!(contest: contest)
        submission_1 = Submission.create!(problem: problem, account: account, status: 'failed')
        submission_2 = Submission.create!(problem: problem, account: account, status: 'passed')

        submission_1.reload
        submission_2.reload

        expected_time =
          (submission_2.created_at - contest.started_at) +
          Rails.configuration.failed_submission_time_penalty

        expect(TeamTimeService.new(contest: contest).call(account: account)).to eq(expected_time)
      end

      it 'accounts for multiple failed submissions' do
        problem = Problem.create!(contest: contest)
        submission_1 = Submission.create!(problem: problem, account: account, status: 'failed')
        submission_2 = Submission.create!(problem: problem, account: account, status: 'failed')
        submission_3 = Submission.create!(problem: problem, account: account, status: 'passed')

        submission_1.reload
        submission_2.reload
        submission_3.reload

        expected_time =
          (submission_3.created_at - contest.started_at) +
          2 * Rails.configuration.failed_submission_time_penalty

        expect(TeamTimeService.new(contest: contest).call(account: account)).to eq(expected_time)
      end

      it 'calculates the time from the first passing submission' do
        problem = Problem.create!(contest: contest)
        submission_1 = Submission.create!(problem: problem, account: account, status: 'passed')
        submission_2 = Submission.create!(problem: problem, account: account, status: 'passed')

        submission_1.reload
        submission_2.reload

        expected_time = submission_1.created_at - contest.started_at
        expect(TeamTimeService.new(contest: contest).call(account: account)).to eq(expected_time)
      end

      it 'ignores failures after passed runs' do
        problem = Problem.create!(contest: contest)
        submission_1 = Submission.create!(problem: problem, account: account, status: 'passed')
        submission_2 = Submission.create!(problem: problem, account: account, status: 'failed')

        submission_1.reload
        submission_2.reload

        expected_time = submission_1.created_at - contest.started_at
        expect(TeamTimeService.new(contest: contest).call(account: account)).to eq(expected_time)
      end
    end
  end
end
