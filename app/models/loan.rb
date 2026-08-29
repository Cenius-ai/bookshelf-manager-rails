class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_at, presence: true
  validate :book_must_be_available, on: :create
  validate :user_cannot_borrow_same_book_twice, on: :create

  scope :active, -> { where(returned_at: nil) }
  scope :returned, -> { where.not(returned_at: nil) }
  scope :overdue, -> { active.where("borrowed_at < ?", 14.days.ago) }

  def active?
    returned_at.nil?
  end

  def returned?
    returned_at.present?
  end

  def return!
    update!(returned_at: Time.current)
  end

  def due_date
    (borrowed_at + 14.days).to_date
  end

  def overdue?
    active? && due_date < Date.current
  end

  private

  def book_must_be_available
    if book.present? && !book.available?
      errors.add(:book, "is already borrowed")
    end
  end

  def user_cannot_borrow_same_book_twice
    if user.present? && book.present? && user.active_loan_for(book).present?
      errors.add(:book, "you already have this book on loan")
    end
  end
end
