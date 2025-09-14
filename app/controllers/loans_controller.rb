class LoansController < ApplicationController
  before_action :authenticate_user!

  def my_loans
    # só os empréstimos não devolvidos do usuário atual
    @my_loans = current_user.loans.where(returned: false).includes(:book)
  end
end
