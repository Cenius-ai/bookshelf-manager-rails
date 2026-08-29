class LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:create]

  def create
    @loan = current_user.loans.build(
      book: @book,
      borrowed_at: Time.current
    )

    if @loan.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to book_path(@book), notice: "Book borrowed successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("loan_status", partial: "books/loan_status", locals: { book: @book, user_loan: nil, error: @loan.errors.full_messages.to_sentence }) }
        format.html { redirect_to book_path(@book), alert: @loan.errors.full_messages.to_sentence }
      end
    end
  end

  def update
    @loan = current_user.loans.find(params[:id])
    @book = @loan.book

    if @loan.active? && @loan.return!
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to book_path(@book), notice: "Book returned successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("loan_status", partial: "books/loan_status", locals: { book: @book, user_loan: @loan, error: "Unable to return book." }) }
        format.html { redirect_to book_path(@book), alert: "Unable to return book." }
      end
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to books_path, alert: "Book not found."
  end
end
