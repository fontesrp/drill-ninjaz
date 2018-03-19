class Question < ApplicationRecord

  belongs_to :drill_group

  has_many :attempts, foreign_key: :current_question_id, dependent: :nullify
  has_many :users, through: :attempts
  has_many :solutions, dependent: :destroy
  accepts_nested_attributes_for :solutions, reject_if: :all_blank, allow_destroy: true

  VALID_LANGUAGES = %w(clojure coffeescript common lisp c c++ c# d dart
    elixir erlang free pascal fortran f# go groovy haskell java
    javascript julia kotlin lua nim objective-c ocaml gnu octave perl php
    python2 python3 r ruby rust scala smalltalk swift3 tcl typescript
    visual basic)

  before_validation :downcase_lang
  validate :valid_lang

  private

  def downcase_lang
    self.language&.downcase!
  end

  def valid_lang
    if !VALID_LANGUAGES.include? language
      errors.add :language,  "invalid"
    end
  end
end
