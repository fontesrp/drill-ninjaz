class Question < ApplicationRecord

  belongs_to :drill_group

  has_many :attempts, foreign_key: :current_question_id, dependent: :nullify
  has_many :users, through: :attempts
end
