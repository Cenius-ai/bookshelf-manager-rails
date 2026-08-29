module Admin
  class BooksController < BaseController
    def new
      @book = Book.new
    end

    def create
      @book = Book.new(book_params)

      if @book.save
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to books_path, notice: "Book added successfully." }
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "new_book_form",
              partial: "admin/books/form",
              locals: { book: @book }
            )
          end
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    private

    def book_params
      params.require(:book).permit(:title, :author, :isbn, :description, :cover_image_url)
    end
  end
end
