class DrillGroup < ApplicationRecord

  belongs_to :user

  has_many :questions, dependent: :destroy
  has_many :attempts, dependent: :destroy
  has_many :user_attempts, through: :attempts, source: :user 

  def available_levels
    [['beginner', 'Beginner'], ['intermediate', 'Intermediate'], ['advanced', 'Advanced']]
  end
end
