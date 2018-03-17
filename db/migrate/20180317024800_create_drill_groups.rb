class CreateDrillGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :drill_groups do |t|
      t.string :name
      t.string :description
      t.integer :points
      t.string :level
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
