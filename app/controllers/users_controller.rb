class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :find_user, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all, items: Settings.page.total_element)
  end

  def show
    @pagy, @microposts = pagy(@user.microposts.recent_posts,
                              items: Settings.page.total_element)
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".info_activate_account"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t("update_success")
      redirect_to @user
    else
      flash[:danger] = t("update_fail")
      render :edit
    end
  end

  def destroy
    if @user&.destroy
      flash[:success] = t("delete_success")
    else
      flash[:danger] = t("delete_fail")
    end
    redirect_to users_url
  end

  def following
    @title = "Following"
    @pagy, @users = pagy(@user.followings, items: Settings.page.total_element)
    render :show_follow
  end

  def followers
    @title = "Followers"
    @pagy, @users = pagy(@user.followers, items: Settings.page.total_element)
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("user_not_found")
    redirect_to root_path
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
