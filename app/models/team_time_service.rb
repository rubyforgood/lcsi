class TeamTimeService
  def initialize(contest:)
    @contest = contest
  end

  def call(account:)
    @account = account

    if passed_submissions.any?
      first_passed_submission.created_at - @contest.started_at + time_penalty
    else
      0
    end
  end

  private

  def submissions
    @account.submissions.where(problem: @contest.problems)
  end

  def passed_submissions
    submissions.where(status: 'passed')
  end

  def first_passed_submission
    passed_submissions.first
  end

  def time_penalty
    submissions.select do |submission|
      submission.status == 'failed' && submission.created_at < first_passed_submission.created_at
    end.map do |submission|
      Rails.configuration.failed_submission_time_penalty
    end.reduce(0, :+)
  end
end
