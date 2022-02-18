class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
    create_post @micropost
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".flash_delete_success"
    else
      flash[:danger] = t ".flash_delete_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "invalid_delete"
    redirect_to root_url
  end

  def create_post micropost
    if micropost.save
      flash[:success] = t ".flash_success"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy User.feed(current_user_following).recent_posts
      render "static_page/home"
    end
  end
end
