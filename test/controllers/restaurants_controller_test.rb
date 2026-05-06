require "test_helper"

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  test "indexにアクセスできる" do
    get restaurants_path
    assert_response :success
  end
end