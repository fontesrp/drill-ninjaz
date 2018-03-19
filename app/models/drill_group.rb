class DrillGroup < ApplicationRecord

  belongs_to :user

  has_many :questions, dependent: :destroy
  has_many :attempts, dependent: :destroy
  has_many :user_attempts, through: :attempts, source: :user

  def available_levels
    [['beginner', 'Beginner'], ['intermediate', 'Intermediate'], ['advanced', 'Advanced']]
  end

  validates :name, :description, :points, presence: true

  validate :valid_level

  private

  def valid_level
    valids = available_levels.map { |lvl| lvl.first }
    unless valids.include? level
      errors.add :level, "invalid"
    end
  end
end
