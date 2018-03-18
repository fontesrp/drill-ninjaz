class AddLanguageToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :language, :string
  end
end
