class User < ApplicationRecord

  has_secure_password

  has_many :drill_groups, dependent: :destroy
  has_many :attempts, dependent: :destroy
end
