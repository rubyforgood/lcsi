class TeamScoreService
  def initialize(contest:)
    @contest = contest
  end

  def call(account:)
    account.submissions.where(status: 'passed', problem: @contest.problems).count
  end
end
