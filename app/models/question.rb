class Question < ApplicationRecord

  belongs_to :drill_group

  has_many :attempts, dependent: :nullify
end
