require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "未ログイン時は管理画面にアクセスできない" do
    get admin_users_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "一般ユーザーは管理画面にアクセスできない" do
    log_in_as(@non_admin)
    get admin_users_path
    assert_redirected_to root_url
  end

  test "管理者は管理画面にアクセスできる" do
    log_in_as(@admin)
    get admin_users_path
    assert_response :success
  end

  test "管理画面にユーザー一覧が表示される" do
    log_in_as(@admin)
    get admin_users_path
    assert_select "table"
    assert_select "td", text: @admin.name
    assert_select "td", text: @non_admin.name
  end
end
