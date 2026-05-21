class AuditLogsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def index
    @audit_logs = AuditLog.includes(:user).
      order(created_at: :desc).
      limit(100)
  end

  def export_csv
    audit_logs = AuditLog.includes(:user).
      order(created_at: :desc)

    respond_to do |format|
      format.csv do
        send_data generate_csv(audit_logs),
                  filename: "audit_logs_#{Date.current}.csv",
                  type: "text/csv; charset=utf-8"
      end
    end
  end

  private

  # CSV Injection 対策：=, +, -, @, タブ, 改行で始まる文字列にシングルクォートを付与し
  # Excel / LibreOffice に数式として解釈させない
  def sanitize_csv_cell(value)
    return value unless value.is_a?(String)

    value.start_with?("=", "+", "-", "@", "\t", "\r") ? "'#{value}" : value
  end

  def generate_csv(audit_logs)
    require "csv"

    CSV.generate(headers: true) do |csv|
      csv << %w(id user_id user_name action target_type target_id ip_address user_agent created_at)

      audit_logs.each do |log|
        csv << [
          log.id,
          log.user_id,
          sanitize_csv_cell(log.user.name),
          log.action,
          log.target_type,
          log.target_id,
          log.ip_address,
          sanitize_csv_cell(log.user_agent),
          log.created_at.strftime("%Y/%m/%d %H:%M:%S"),
        ]
      end
    end
  end
end
