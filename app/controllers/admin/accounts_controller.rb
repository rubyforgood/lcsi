module Admin
  class AccountsController < AdminController
    def index
      @contest  = Contest.instance
      @accounts = @contest.accounts
    end

    def new
      @contest = Contest.instance
      @account = @contest.accounts.build
    end

    def create
      @contest = Contest.instance
      @account = @contest.accounts.build account_params.merge(password: TokenPhrase.generate)

      if @account.save
        redirect_to admin_accounts_path
      else
        render action: 'new'
      end
    end

    private

    def account_params
      params.require(:account).permit(:name, :username)
    end
  end
end
