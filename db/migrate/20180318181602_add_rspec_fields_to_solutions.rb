class AddRspecFieldsToSolutions < ActiveRecord::Migration[5.1]
  def change
    add_column :solutions, :input, :string
    add_column :solutions, :output, :string
  end
end
