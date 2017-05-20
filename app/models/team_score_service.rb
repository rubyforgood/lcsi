class TeamScoreService
  def initialize(contest:, team:)
    @contest = contest
    @team = team
  end

  def call
    @team.submissions.where(status: 'passed', problem: @contest.problems).count
  end
end
