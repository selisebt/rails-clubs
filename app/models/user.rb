class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :role
  has_many :memberships, dependent: :destroy
  has_many :clubs, through: :memberships
  has_one :attachment, as: :attachable, dependent: :destroy

  scope :search_by_name, ->(query) { where("name LIKE ?", "%#{query}%") if query.present? }
  scope :search_by_email, ->(query) { where("email LIKE ?", "%#{query}%") if query.present? }
end
