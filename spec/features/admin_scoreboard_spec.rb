require 'rails_helper'

RSpec.feature 'Admin scoreboard', type: :feature do
  let(:contest) { Contest.instance }

  before do
    contest.start
    contest.save
  end

  scenario 'admin scoreboard is not accessible to participants' do
    visit admin_contest_scoreboard_path(contest)

    expect(current_path).to eq(new_session_path)
  end

  context "as an admin" do
    include_context "an authorized admin"

    scenario 'admin scoreboard is accessible to admins' do
      # TODO Update when authorization is in place
      visit admin_contest_scoreboard_path(contest)

      expect(current_path).to eq(admin_contest_scoreboard_path(contest))
    end

    scenario 'an account without activity is shown', :include_contest do
      account = Account.create!(contest: contest, name: 'account 1')

      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text('account 1')
    end

    scenario 'a account with activity is shown' do
      account = Account.create!(contest: contest, name: 'account 1')
      problem = Problem.create!(contest: contest)
      submission = Submission.create!(account: account, problem: problem)

      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text('account 1')

    end

    scenario 'accounts are ranked by current score' do
      account_1 = Account.create!(contest: contest, name: 'account 1')
      account_2 = Account.create!(contest: contest, name: 'account 2')
      problem = Problem.create!(contest: contest)

      Submission.create!(problem: problem, account: account_1, status: 'failed')
      Submission.create!(problem: problem, account: account_2, status: 'passed')

      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text(/account 2.*account 1/)
    end

    scenario 'ties are broken by time' do
      account_1 = Account.create!(contest: contest, name: 'account 1')
      account_2 = Account.create!(contest: contest, name: 'account 2')
      problem = Problem.create!(contest: contest)

      submission_1 = Submission.create!(problem: problem, account: account_2, status: 'passed')
      submission_2 = Submission.create!(problem: problem, account: account_1, status: 'passed')

      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text(/account 2.*account 1/)
    end

    scenario 'problem numbers are shown in the table header' do
      8.times { Problem.create!(contest: contest) }

      visit admin_contest_scoreboard_path(contest)

      8.times do |index|
        expect(page).to have_text(index + 1)
      end
    end

    scenario 'there is a account column' do
      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text(/Account/)
    end

    scenario 'there is a score column' do
      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text(/Score/)
    end

    scenario 'there is a time + penalty column' do
      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text(/Time \+ Penalty/)
    end

    scenario 'unattempted problems show a 0 total number of submissions' do
      account = Account.create!(contest: contest, name: 'account 1')
      problem = Problem.create!(contest: contest)

      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text('0')
    end

    scenario 'unsolved problems show the total number of submissions' do
      account = Account.create!(contest: contest, name: 'account 1')
      problem = Problem.create!(contest: contest)

      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'failed')

      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text('4')
    end

    scenario 'solved problems show the total number of submissions' do
      account = Account.create!(contest: contest, name: 'account 1')
      problem = Problem.create!(contest: contest)

      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'passed')

      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text('4')
    end

    scenario 'problems show the total number of submissions up to the first success' do
      account = Account.create!(contest: contest, name: 'account 1')
      problem = Problem.create!(contest: contest)

      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'passed')
      submission = Submission.create!(account: account, problem: problem, status: 'failed')
      submission = Submission.create!(account: account, problem: problem, status: 'passed')

      visit admin_contest_scoreboard_path(contest)

      expect(page).to have_text('4')
    end

    scenario 'score is shown for each account' do
      account = Account.create!(contest: contest, name: 'account 1')
      problem_1 = Problem.create!(contest: contest)
      problem_2 = Problem.create!(contest: contest)
      problem_3 = Problem.create!(contest: contest)

      submission = Submission.create!(account: account, problem: problem_1, status: 'failed')
      submission = Submission.create!(account: account, problem: problem_1, status: 'failed')
      submission = Submission.create!(account: account, problem: problem_1, status: 'failed')
      submission = Submission.create!(account: account, problem: problem_1, status: 'passed')

      submission = Submission.create!(account: account, problem: problem_2, status: 'failed')
      submission = Submission.create!(account: account, problem: problem_2, status: 'failed')
      submission = Submission.create!(account: account, problem: problem_2, status: 'failed')

      submission = Submission.create!(account: account, problem: problem_3, status: 'passed')

      visit admin_contest_scoreboard_path(contest)

      within('tbody') do
        expect(page).to have_text('2')
      end
    end

    scenario 'time + penalty is shown for each account' do
      account = Account.create!(contest: contest, name: 'account 1')
      problem_1 = Problem.create!(contest: contest)
      problem_2 = Problem.create!(contest: contest)
      problem_3 = Problem.create!(contest: contest)

      Submission.create!(account: account, problem: problem_1, status: 'failed')
      Submission.create!(account: account, problem: problem_1, status: 'failed')
      Submission.create!(account: account, problem: problem_1, status: 'failed')
      submission_1 = Submission.create!(account: account, problem: problem_1, status: 'passed')

      Submission.create!(account: account, problem: problem_2, status: 'failed')
      Submission.create!(account: account, problem: problem_2, status: 'failed')
      Submission.create!(account: account, problem: problem_2, status: 'failed')

      submission_2 = Submission.create!(account: account, problem: problem_3, status: 'passed')

      submission_1.reload
      submission_2.reload

      visit admin_contest_scoreboard_path(contest)

      time_plus_penalty =
        (submission_1.created_at - Contest.instance.started_at) +
        (submission_2.created_at - Contest.instance.started_at) +
        Rails.configuration.failed_submission_time_penalty * 3

      within('tbody') do
        expect(page).to have_text(Time.at(time_plus_penalty).utc.strftime('%H:%M:%S'))
      end
    end
  end
end
