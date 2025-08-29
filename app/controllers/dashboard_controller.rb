class DashboardController < ApplicationController
  # 🔒 Garante que só entra se estiver logado
  before_action :authenticate_user!

  def index
    # Aqui você pode mostrar informações do usuário logado
  end
end
