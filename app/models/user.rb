class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :accounts
  has_many :categories
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
