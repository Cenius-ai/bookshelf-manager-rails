class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show]

  def index
    @books = Book.search(params[:query])
                 .includes(:loans)
                 .order(:title)
  end

  def show
    @active_loan = @book.active_loan
    @user_loan = current_user.active_loan_for(@book)
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to books_path, alert: "Book not found."
  end
end
