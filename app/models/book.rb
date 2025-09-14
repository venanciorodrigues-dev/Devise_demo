class Book < ApplicationRecord
  validates :title, :author, presence: true

  # Relacionamento com empréstimos
  has_many :loans

  # Método para verificar se o livro está disponível
  def available?
    available
  end
end
