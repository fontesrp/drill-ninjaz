class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.text :description
      t.references :drill_group, foreign_key: true, index: true

      t.timestamps
    end
  end
end
