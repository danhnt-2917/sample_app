class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate params[:session][:password]
      check_activate user
    else
      flash.now[:danger] = t ".invalid"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def check_remember user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def check_activate user
    if user.activated?
      log_in user
      check_remember user
      redirect_back_or user
    else
      flash[:warning] = t ".account_not_activated"
      redirect_to root_url
    end
  end
end
