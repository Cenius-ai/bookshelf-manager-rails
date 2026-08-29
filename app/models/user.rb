class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum :role, { member: 0, admin: 1 }

  has_many :loans, dependent: :destroy
  has_many :borrowed_books, through: :loans, source: :book

  validates :name, presence: true

  def admin?
    role == "admin"
  end

  def active_loan_for(book)
    if loans.loaded?
      loans.to_a.find { |l| l.book_id == book.id && l.returned_at.nil? }
    else
      loans.find_by(book: book, returned_at: nil)
    end
  end
end
