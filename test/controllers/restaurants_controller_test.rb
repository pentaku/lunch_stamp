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

  test "未ログインの場合、showはログインページへリダイレクトされる" do
    get restaurant_path("test_shop_1")
    assert_redirected_to login_url
  end

  test "ログイン済みの場合、showにアクセスできる" do
    log_in_as(@user)

    shop = {
      "id" => "test_shop_1",
      "name" => "テスト店舗",
      "address" => "東京都中央区日本橋人形町",
      "genre" => { "name" => "和食" },
      "large_area" => { "name" => "東京" },
      "budget" => { "average" => "1000円" },
      "photo" => {
        "mobile" => {
          "l" => "https://example.com/test.jpg",
        },
      },
      "urls" => {
        "pc" => "https://example.com",
      },
    }

    original_method = HotpepperService.method(:find)

    HotpepperService.define_singleton_method(:find) do |_hotpepper_id|
      shop
    end

    get restaurant_path("test_shop_1")
    assert_response :success
  ensure
    HotpepperService.define_singleton_method(:find, original_method)
  end
end
