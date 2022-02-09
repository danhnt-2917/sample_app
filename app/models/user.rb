class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true,
    length: {maximum: Settings.validate.name.max_length}

  validates :email, presence: true,
    length: {maximum: Settings.validate.email.max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.validate.password.min_length}

  has_secure_password

  before_save{email.downcase!}
end
