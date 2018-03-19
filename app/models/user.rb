class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
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

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    self.save
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired



  private

  #Converts emails to all lower-case
  def downcase_email
    self.email = email.downcase
  end

  #Creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(self.activation_token)
  end
end
