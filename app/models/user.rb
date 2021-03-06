class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  attr_accessor :remember_token, :activation_token, :reset_token

  validates :name, presence: true,
    length: {maximum: Settings.validate.name.max_length}

  validates :email, presence: true,
    length: {maximum: Settings.validate.email.max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.validate.password.min_length}

  has_secure_password

  has_many :active_relationships, class_name: Relationship.name,
                                  foreign_key: :follower_id,
                                  dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
                                  foreign_key: :followed_id,
                                  dependent: :destroy

  has_many :microposts, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_save{email.downcase!}
  before_create :create_activation_digest

  scope :feed, ->id{Micropost.where user_id: id}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
              end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                    reset_sent_at: Time.zone.now
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.time.expired_time.hours.ago
  end

  # def feed
  #   Micropost.where user_id: (following_ids << id)
  # end

  def follow other_user
    followings << other_user
  end

  def unfollow other_user
    followings.delete other_user
  end

  def following? other_user
    followings.include? other_user
  end
end
