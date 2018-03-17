class Question < ApplicationRecord

  belongs_to :drill_group

  has_many :attempts, foreign_key: :current_question_id, dependent: :nullify
  has_many :users, through: :attempts
  has_many :solutions, dependent: :destroy
  accepts_nested_attributes_for :solutions, reject_if: :all_blank, allow_destroy: true
end
