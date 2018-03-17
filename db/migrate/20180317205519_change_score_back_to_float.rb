class ChangeScoreBackToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :attempts, :score, :float
  end
end
