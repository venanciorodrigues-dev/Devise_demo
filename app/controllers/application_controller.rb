class ApplicationController < ActionController::Base
  # Redireciona para login após logout
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
