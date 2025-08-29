class HomeController < ApplicationController
  def index
    # Se estiver logado, manda para a dashboard
    if user_signed_in?
      redirect_to dashboard_path
    end
    # Senão, continua mostrando a página pública
  end
end
