class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  attr_accessor :remember_token

  validates :name, presence: true,
    length: {maximum: Settings.validate.name.max_length}

  validates :email, presence: true,
    length: {maximum: Settings.validate.email.max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.validate.password.min_length}

  has_secure_password

  before_save{email.downcase!}

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
              end
      BCrypt::Password.create string, cost: cost
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end
end
