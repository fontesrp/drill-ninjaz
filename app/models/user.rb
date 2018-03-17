class User < ApplicationRecord

  has_secure_password

  has_many :drill_groups, dependent: :destroy
  has_many :attempts, dependent: :destroy
  has_many :drill_group_attempts, through: :attempts, source: :drill_group
  has_many :current_questions, class_name: "Question", through: :attempts

  validates :first_name, :last_name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email,
    presence: true,
    uniqueness: true,
    format: VALID_EMAIL_REGEX

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
