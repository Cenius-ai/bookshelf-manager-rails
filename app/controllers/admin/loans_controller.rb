module Admin
  class LoansController < BaseController
    def index
      @active_loans = Loan.active.includes(:user, :book).order(borrowed_at: :desc)
      @overdue_loans = Loan.overdue.includes(:user, :book)
    end
  end
end
