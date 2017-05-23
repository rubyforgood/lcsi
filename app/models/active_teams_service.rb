class ActiveTeamsService
  def initialize(contest:, accounts:)
    @contest = contest
    @accounts = accounts
  end

  def call
    @accounts.reject { |account| account.submissions.where(problem: @contest.problems).empty? }
  end
end
