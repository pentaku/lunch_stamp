require "test_helper"

class VisitsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:michael)
    @restaurant = restaurants(:two)
  end

  # 未ログイン時はログインページにリダイレクト
  test "未ログイン時はcreateできない" do
    assert_no_difference "Visit.count" do
      post restaurant_visit_path(@restaurant.hotpepper_id)
    end
    assert_redirected_to login_url
  end

  test "未ログイン時はdestroyできない" do
    assert_no_difference "Visit.count" do
      delete restaurant_visit_path(@restaurant.hotpepper_id)
    end
    assert_redirected_to login_url
  end

  # ログイン時
  test "ログイン時にcreateできる" do
    log_in_as(@user)
    dummy_shop = {
      "id"         => @restaurant.hotpepper_id,
      "name"       => @restaurant.name,
      "address"    => @restaurant.address,
      "genre"      => { "name" => @restaurant.genre },
      "small_area" => { "name" => @restaurant.area },
      "budget"     => { "name" => @restaurant.budget },
      "photo"      => { "pc" => { "l" => @restaurant.photo_url } },
      "urls"       => { "pc" => @restaurant.url }
    }

    original_method = HotpepperService.method(:find)
    HotpepperService.define_singleton_method(:find) { |_id| dummy_shop }

    assert_difference "Visit.count", 1 do
      post restaurant_visit_path(@restaurant.hotpepper_id)
    end
    assert_redirected_to restaurant_path(@restaurant.hotpepper_id)
  ensure
    HotpepperService.define_singleton_method(:find, original_method)
  end

  test "ログイン時にdestroyできる" do
    log_in_as(@user)
    visit = Visit.create!(
      user:       @user,
      restaurant: @restaurant,
      visited_at: Date.current
    )
    assert_difference "Visit.count", -1 do
      delete restaurant_visit_path(@restaurant.hotpepper_id)
    end
    assert_redirected_to restaurant_path(@restaurant.hotpepper_id)
  end

end