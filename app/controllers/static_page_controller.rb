class StaticPageController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy User.feed(current_user_following).recent_posts
  end

  def help; end

  def about; end

  def contact; end
end
