require "test_helper"

class PasswordResets < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class ForgotPasswordFormTest < PasswordResets
  test "パスワード再設定ページにアクセスできる" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
  end

  test "メールアドレスが空の場合は再表示される" do
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_response :unprocessable_entity
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end
end

class PasswordResetForm < PasswordResets
  def setup
    super
    @user = users(:michael)
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    @reset_user = assigns(:user)
  end
end

class PasswordFormTest < PasswordResetForm
  test "有効なメールアドレスで再設定リンクが送信される" do
    assert_not_nil @reset_user.reset_digest
    assert_not_nil @reset_user.reset_sent_at
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "メールアドレスが不一致の場合はトップへリダイレクトされる" do
    get edit_password_reset_path(@reset_user.reset_token, email: "")
    assert_redirected_to root_url
  end

  test "未有効化ユーザーはトップへリダイレクトされる" do
    @reset_user.toggle!(:activated)
    get edit_password_reset_path(@reset_user.reset_token,
                                 email: @reset_user.email)
    assert_redirected_to root_url
  end

  test "正しいメールでもトークンが無効なら拒否される" do
    get edit_password_reset_path('wrong token', email: @reset_user.email)
    assert_redirected_to root_url
  end

  test "正しいメールとトークンで再設定フォームが表示される" do
    get edit_password_reset_path(@reset_user.reset_token,
                                 email: @reset_user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", @reset_user.email
  end
end

class PasswordUpdateTest < PasswordResetForm
  test "パスワードと確認用が一致しない場合はエラーになる" do
    patch password_reset_path(@reset_user.reset_token),
          params: {
            email: @reset_user.email,
            user: {
              password: "foobaz",
              password_confirmation: "barquux",
            },
          }
    assert_select 'div#error_explanation'
  end

  test "パスワードが空の場合はエラーになる" do
    patch password_reset_path(@reset_user.reset_token),
          params: {
            email: @reset_user.email,
            user: {
              password: "",
              password_confirmation: "",
            },
          }
    assert_select 'div#error_explanation'
  end

  test "正しいパスワードで再設定が成功する" do
    patch password_reset_path(@reset_user.reset_token),
          params: {
            email: @reset_user.email,
            user: {
              password: "foobaz",
              password_confirmation: "foobaz",
            },
          }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to @reset_user
  end
end
