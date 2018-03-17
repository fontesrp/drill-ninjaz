class Score < ApplicationRecord
  belongs_to :user
  belongs_to :drill_group
end
