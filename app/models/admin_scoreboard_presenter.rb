class AdminScoreboardPresenter
  attr_reader :ranked_accounts, :problems, :page_refresh_interval

  def initialize
    @contest = Contest.instance
    @ranked_accounts = RankedTeamsService.new(contest: @contest).call
    @problems = @contest.problems
    @page_refresh_interval = Rails.configuration.page_refresh_interval
  end

  def attempts(account:, problem:)
    ProblemAttemptsService.new(problem: problem, account: account).call
  end

  def score(account:)
    TeamScoreService.new(contest: Contest.instance).call(account: account)
  end

  def time_plus_penalty(account:)
    Time.at(TeamTimeService.new(contest: Contest.instance).call(account: account)).utc.strftime('%H:%M:%S')
  end

  def color(account:, problem:)
    if problem.submissions.where(account: account, status: 'passed').any?
      return 'lightgreen'
    elsif problem.submissions.where(account: account, status: 'pending').any?
      return 'yellow'
    elsif problem.submissions.where(account: account, status: 'failed').any?
      return 'orange'
    end
  end
end
