class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.references :user, foreign_key: true
      t.references :drill_group, foreign_key: true
      t.integer :times_taken
      t.float :latest
      t.float :highest

      t.timestamps
    end
  end
end
