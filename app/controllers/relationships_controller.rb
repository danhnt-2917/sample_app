class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :create
  before_action :find_user_followed, only: :destroy

  def create
    current_user.follow(@user)
    redirect_to @user
  end

  def destroy
    current_user.unfollow(@user)
    redirect_to @user
  end

  private

  def find_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t("user_not_found")
    redirect_to root_path
  end

  def find_user_followed
    @user = Relationship.find_by(id: params[:id]).followed
    return if @user

    flash[:danger] = t("user_not_found")
    redirect_to root_path
  end
end
