class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url, status: :see_other
    end
  end

  def redirect_if_logged_in
    redirect_to root_url if logged_in?
  end

  def admin_user
    redirect_to root_url, status: :see_other unless current_user&.admin?
  end

  def create_audit_log(action:, target: nil)
    return unless logged_in?

    AuditLog.create!(
      user: current_user,
      action: action,
      target_type: target&.class&.name,
      target_id: target&.id,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
    )
  rescue StandardError => e
    Rails.logger.error("[AuditLog] 記録失敗: #{e.message}")
  end
end
