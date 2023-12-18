class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :recoverable, :rememberable
  has_many :user_keywords, dependent: :destroy
  has_many :keywords, through: :user_keywords
end
