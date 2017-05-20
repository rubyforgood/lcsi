class RankedTeamsService
  def initialize(teams: , contest:)
    @teams = teams
    @contest = contest
  end

  def  call
    @teams.sort do |team_1, team_2|
      [TeamScoreService.new(team: team_2, contest: @contest).call,
       TeamTimeService.new(team: team_1, contest: @contest).call] <=>
        [TeamScoreService.new(team: team_1, contest: @contest).call,
         TeamTimeService.new(team: team_2, contest: @contest).call]
    end
  end
end
