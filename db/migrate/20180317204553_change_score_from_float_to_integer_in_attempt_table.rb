class ChangeScoreFromFloatToIntegerInAttemptTable < ActiveRecord::Migration[5.1]
  def change
    change_column :attempts, :score, :integer
  end
end
