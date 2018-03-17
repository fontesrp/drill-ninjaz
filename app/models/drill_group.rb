class DrillGroup < ApplicationRecord

  belongs_to :user

  has_many :questions, dependent: :destroy
  has_many :scores, dependent: :destroy
end
