class TeamTimeService
  def initialize(contest:, team:)
    @contest = contest
    @team = team
  end

  def call
    if submissions.any?
      submissions.first.created_at - @contest.started_at + time_penalty
    else
      Float::INFINITY
    end
  end

  private

    def submissions
      @team.submissions.where(problem: @contest.problems)
    end

    def time_penalty
      submissions.select do |submission|
        submission.status == 'failed'
      end.map do |submission|
        Rails.configuration.failed_submission_time_penalty
      end.reduce(0, :+)
    end
end
