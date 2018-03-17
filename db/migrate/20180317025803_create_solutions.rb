class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.text :answer
      t.references :question, foreign_key: true, index: true

      t.timestamps
    end
  end
end
