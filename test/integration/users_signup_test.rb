require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
  test "無効な新規登録情報ではユーザー登録できない" do
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar",
        },
      }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "有効な新規登録情報ではアカウント有効化メールが送信される" do
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "Example User",
          email: "user@example.com",
          password: "password",
          password_confirmation: "password",
        },
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "ログイン済みユーザーは新規登録ページにアクセスするとトップページへリダイレクトされる" do
    log_in_as(users(:michael))

    get signup_path

    assert_redirected_to root_url
  end

  test "ログイン済みユーザーは新規登録処理を実行するとトップページへリダイレクトされる" do
    log_in_as(users(:michael))

    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "Another User",
          email: "another@example.com",
          password: "password",
          password_confirmation: "password",
        },
      }
    end

    assert_redirected_to root_url
  end
end

class AccountActivationTest < UsersSignup
  def setup
    super
    post users_path, params: {
      user: {
        name: "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password",
      },
    }
    @user = assigns(:user)
  end

  test "新規登録直後のユーザーは有効化されていない" do
    assert_not @user.activated?
  end

  test "アカウント有効化前のユーザーはログインできない" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "無効な有効化トークンではログインできない" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not is_logged_in?
  end

  test "無効なメールアドレスではログインできない" do
    get edit_account_activation_path(@user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  test "有効な有効化トークンとメールアドレスでログインできる" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
