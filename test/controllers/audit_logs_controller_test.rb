require "test_helper"

class AuditLogsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "未ログイン時はindexにアクセスできない" do
    get audit_logs_path
    assert_redirected_to login_url
  end

  test "ログイン済みはindexにアクセスできる" do
    log_in_as(@user)
    get audit_logs_path
    assert_response :success
  end

  test "ログイン済みはCSVをダウンロードできる" do
    log_in_as(@user)
    get export_csv_audit_logs_path(format: :csv)
    assert_response :success
    assert_equal "text/csv; charset=utf-8", response.content_type
  end

end