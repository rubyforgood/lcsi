class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_account
    # TODO Update when authorization is in place
    redirect_to root_path unless current_account
  end

  def current_account
    @current_account ||= session[:current_account_id] &&
      Account.find_by(id: session[:current_account_id])
  end

  def current_admin
    Rails.logger.info("Deprecated current_admin method called from #{caller[1]}")
    current_account
  end
end
