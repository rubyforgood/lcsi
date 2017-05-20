class TeamTimeService
  def initialize(contest:)
    @contest = contest
  end

  def call(team:)
    @team = team

    if submissions.any?
      submissions.first.created_at - @contest.started_at + time_penalty
    else
      0
    end
  end

  private

  def submissions
    @submissions ||= @team.submissions.where(problem: @contest.problems)
  end

  def passed_submissions
    submissions.where(status: 'passed')
  end

  def first_passed_submission
    passed_submissions.first
  end

  def submissions_time
    submissions.map do |submission|
      submission.created_at - @contest.started_at
    end.reduce(0, :+)
  end

  def time_penalty
    submissions.select do |submission|
      submission.status == 'failed'
    end.map do |submission|
      Rails.configuration.failed_submission_time_penalty
    end.reduce(0, :+)
  end
end
