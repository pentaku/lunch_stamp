class AuditLog < ApplicationRecord
  belongs_to :user

  # ログの種類を定義
  ACTIONS = %w(
    login
    logout
    visit_create
    visit_destroy
  ).freeze

  validates :action, presence: true, inclusion: { in: ACTIONS }
end
