class Micropost < ApplicationRecord
  validates :user_id, presence: true

  validates :content, presence: true,
            length: {maximum: Settings.validate.content.max_length}

  validates :image,
            content_type: {in: Settings.micropost.image,
                           message: I18n.t("microposts.validates.validate_img")},
            size: {less_than: Settings.validate.img.byte.megabytes,
                   message: I18n.t("microposts.validates.validate_img_size")}

  belongs_to :user
  has_one_attached :image

  scope :recent_posts, ->{order created_at: :desc}

  def display_image
    image.variant(resize_to_limit: Settings.range_500)
  end
end
