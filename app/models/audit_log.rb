# app/models/audit_log.rb
class AuditLog < ApplicationRecord
  belongs_to :user

  # ログの種類を定義
  ACTIONS = %w[
    login
    logout
    visit_create
    visit_destroy
  ].freeze

  # アクションが空でないこと、かつ ACTIONS に含まれる文字であることを検証
  validates :action, presence: true, inclusion: { in: ACTIONS }
end