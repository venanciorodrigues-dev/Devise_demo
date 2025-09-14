class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[show edit update destroy borrow return]

  # Verificação do Pundit
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  # --- LISTA DE LIVROS ---
  def index
    @books = policy_scope(Book)
  end

  # --- LIVROS EMPRESTADOS (ADMIN) ---
  def borrowed
    authorize Book, :borrowed?
    @borrowed_books = Book.joins(:loans).where(loans: { returned: false })
  end

  # --- DETALHES DE UM LIVRO ---
  def show
    authorize @book
  end

  # --- NOVO LIVRO ---
  def new
    @book = Book.new
    authorize @book
  end

  def create
    @book = Book.new(book_params)
    authorize @book

    if @book.save
      redirect_to @book, notice: "Livro criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # --- EDITAR LIVRO ---
  def edit
    authorize @book
  end

  def update
    authorize @book
    if @book.update(book_params)
      redirect_to @book, notice: "Livro atualizado!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # --- DELETAR LIVRO ---
  def destroy
    authorize @book

    if @book.available?
      @book.destroy
      redirect_to books_path, notice: "Livro excluído com sucesso!"
    else
      redirect_to books_path, alert: "Não é possível excluir um livro que está emprestado."
    end
  end

  # --- EMPRÉSTIMO (USUÁRIO COMUM) ---
  def borrow
    authorize @book, :borrow?

    if @book.available?
      Loan.create!(user: current_user, book: @book, due_date: 7.days.from_now, returned: false)
      @book.update(available: false)
      redirect_to books_path, notice: "Você emprestou o livro #{@book.title}."
    else
      redirect_to books_path, alert: "Esse livro já está emprestado."
    end
  end

  # --- DEVOLUÇÃO (USUÁRIO COMUM) ---
  def return
    authorize @book, :borrow?

    loan = @book.loans.find_by(user: current_user, returned: false)

    if loan
      loan.update(returned: true)
      @book.update(available: true)
      redirect_to my_loans_loans_path, notice: "Você devolveu o livro #{@book.title}."
    else
      redirect_to my_loans_loans_path, alert: "Não há empréstimos ativos para este livro."
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :description, :available, :price)
  end
end
