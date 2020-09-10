class ApplicationController < ActionController::Base
  before_action :gon_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { render json: { success: false }, status: 403 }
      format.js { head :forbidden }
    end
  end

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end
