class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :role
  has_many :memberships, dependent: :destroy
  has_many :clubs, through: :memberships
end
