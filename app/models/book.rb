class Book < ApplicationRecord
  has_many :loans, dependent: :destroy
  has_many :borrowers, through: :loans, source: :user

  validates :title, presence: true
  validates :author, presence: true

  scope :search, ->(query) {
    return all if query.blank?
    where("title LIKE ? OR author LIKE ?", "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%")
  }

  def available?
    active_loan.blank?
  end

  def active_loan
    if loans.loaded?
      loans.to_a.find { |l| l.returned_at.nil? }
    else
      loans.find_by(returned_at: nil)
    end
  end

  def current_borrower
    active_loan&.user
  end
end
