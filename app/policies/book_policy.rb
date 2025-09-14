class BookPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all  # todos os livros visíveis para todos
    end
  end

  # --- LISTA DE LIVROS ---
  def index?
    true  # todos podem ver a lista
  end

  # --- DETALHES DE UM LIVRO ---
  def show?
    true  # todos podem ver detalhes
  end

  # --- EMPRÉSTIMO (USUÁRIO COMUM) ---
  def borrow?
    user.present? && !user.admin?  # apenas usuário comum logado
  end

  # --- CRIAR LIVRO (ADMIN) ---
  def create?
    user.present? && user.admin?
  end
  def new?
    create?
  end

  # --- EDITAR LIVRO (ADMIN) ---
  def update?
    user.present? && user.admin?
  end
  def edit?
    update?
  end

  # --- DELETAR LIVRO (ADMIN) ---
  def destroy?
    user.present? && user.admin?
  end

  # --- VER LIVROS EMPRESTADOS (ADMIN) ---
  def borrowed?
    user.present? && user.admin?  # apenas admin
  end
end
