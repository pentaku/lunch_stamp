# app/models/audit_log.rb
class AuditLog < ApplicationRecord
  belongs_to :user

  validates :action, presence: true, inclusion: { in: ACTIONS }

  # ログの種類を定義
  ACTIONS = %w[
    login
    logout
    visit_create
    visit_destroy
  ].freeze
end