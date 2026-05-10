require "test_helper"

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "未ログインの場合、indexはログインページへリダイレクトされる" do
    get restaurants_path
    assert_redirected_to login_url
  end

  test "ログイン済みの場合、indexにアクセスできる" do
    log_in_as(@user)
    get restaurants_path
    assert_response :success
  end
end
