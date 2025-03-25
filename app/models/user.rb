class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :role
  has_many :memberships, dependent: :destroy
  has_many :clubs, through: :memberships
  has_one :attachment, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachment, allow_destroy: true

  scope :search_by_name, ->(query) { where("LOWER(name) LIKE LOWER(?)", "%#{query}%") if query.present? }
  scope :search_by_email, ->(query) { where("LOWER(email) LIKE LOWER(?)", "%#{query}%") if query.present? }
  scope :search, ->(query) { 
    where("LOWER(name) LIKE LOWER(:query) OR LOWER(email) LIKE LOWER(:query)", query: "%#{query}%") if query.present?
  }
end
