class Attempt < ApplicationRecord
  belongs_to :user
  belongs_to :drill_group
  belongs_to :question
end
