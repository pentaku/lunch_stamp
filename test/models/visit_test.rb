require "test_helper"

class VisitTest < ActiveSupport::TestCase
  def setup
    @user       = users(:michael)
    @restaurant = restaurants(:two)
    @visit      = Visit.new(
      user: @user,
      restaurant: @restaurant,
      visited_at: Date.current
    )
  end

  test "有効なvisitは保存できる" do
    assert @visit.valid?
  end

  test "visited_atは必須" do
    @visit.visited_at = nil
    assert_not @visit.valid?
  end

  test "同じユーザーが同じお店に2回登録できない" do
    @visit.save
    duplicate_visit = Visit.new(
      user: @user,
      restaurant: @restaurant,
      visited_at: Date.current
    )

    assert_not duplicate_visit.valid?
  end

  test "user_idは必須" do
    @visit.user = nil
    assert_not @visit.valid?
  end

  test "restaurant_idは必須" do
    @visit.restaurant = nil
    assert_not @visit.valid?
  end
end
