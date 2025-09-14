class ApplicationController < ActionController::Base
  include Pundit

  # Redireciona para login após logout
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  # Para lidar com erros de autorização
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para realizar essa ação."
    redirect_to(request.referrer || root_path)
  end
end
