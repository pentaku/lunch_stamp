require "test_helper"

class HotpepperServiceTest < ActiveSupport::TestCase
  test "searchはAPIレスポンスから店舗一覧を返す" do
    response_data = {
      "results" => {
        "shop" => [
          {
            "id" => "test_shop_1",
            "name" => "テスト店舗",
          },
        ],
      },
    }

    original_method = HotpepperService.method(:fetch)

    HotpepperService.define_singleton_method(:fetch) do |_uri|
      response_data
    end

    restaurants = HotpepperService.search(keyword: "ラーメン")

    assert_equal 1, restaurants.size
    assert_equal "テスト店舗", restaurants.first["name"]
  ensure
    HotpepperService.define_singleton_method(:fetch, original_method)
  end
end
