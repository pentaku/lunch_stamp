require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "有効なユーザーは保存できる" do
    assert @user.valid?
  end

  test "名前は必須" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "メールアドレスは必須" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "名前は50文字以内" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "メールアドレスは255文字以内" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "メールアドレスは一意" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "メールアドレスは小文字で保存される" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "パスワードは空白不可" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "パスワードは最小文字数を満たす必要がある" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "digestがnilのユーザーはauthenticated?でfalseを返す" do
    assert_not @user.authenticated?(:remember, '')
  end
end
