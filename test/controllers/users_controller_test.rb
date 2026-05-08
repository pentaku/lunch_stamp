require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
  end

  test "新規登録ページにアクセスできる" do
    get signup_url
    assert_response :success
  end

  test "未ログイン時はeditにアクセスできない" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "未ログイン時はupdateできない" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "別ユーザーのeditにはアクセスできない" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "別ユーザーのupdateはできない" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "ログイン済みユーザーはマイページにアクセスできる" do
    log_in_as(@user)
    get user_path(@user)
    assert_response :success
    assert_select "h1", "マイページ"
    assert_select ".mypage-progress-text", text: /訪問数：/
  end

  test "未ログイン時はマイページにアクセスできない" do
    get user_path(@user)
    assert_redirected_to login_url
  end

  test "マイページに訪問記録が表示される" do
    log_in_as(@user)
    get user_path(@user)

    assert_select ".mypage-shop-title", restaurants(:one).name
  end

  test "他のユーザーのマイページにはアクセスできない" do
    log_in_as(@user)
    get user_path(@other_user)
    assert_redirected_to root_url
  end
end