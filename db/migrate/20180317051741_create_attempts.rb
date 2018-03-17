class CreateAttempts < ActiveRecord::Migration[5.1]
  def change
    create_table :attempts do |t|
      t.references :user, foreign_key: true
      t.references :drill_group, foreign_key: true
      t.float :score
      t.integer :current_question_id, index: true

      t.timestamps
    end

    add_foreign_key :attempts, :questions, column: :current_question_id
  end
end
