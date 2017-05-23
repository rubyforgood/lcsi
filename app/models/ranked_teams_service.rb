class RankedTeamsService
  def initialize(contest:)
    @contest = contest
  end

  def  call
    team_score_service = TeamScoreService.new(contest: @contest)
    team_time_service = TeamTimeService.new(contest: @contest)

    @contest.accounts.sort do |team_1, team_2|
      [team_score_service.call(account: team_2),
       team_time_service.call(account: team_1)] <=>
        [team_score_service.call(account: team_1),
         team_time_service.call(account: team_2)]
    end
  end
end
