class VisitsController < ApplicationController
  before_action :logged_in_user

  def create
    shop = HotpepperService.find(params[:restaurant_hotpepper_id])

    if shop.blank?
      return redirect_to restaurants_path,
                         alert: "店舗情報が取得できませんでした"
    end

    ActiveRecord::Base.transaction do
      restaurant = Restaurant.find_or_initialize_by(
        hotpepper_id: shop["id"]
      )

      restaurant.assign_attributes(
        name:      shop["name"],
        address:   shop["address"],
        genre:     shop.dig("genre", "name"),
        area:      shop.dig("small_area", "name"),
        budget:    shop.dig("budget", "name"),
        photo_url: shop.dig("photo", "pc", "l"),
        url:       shop.dig("urls", "pc"),
      )

      restaurant.save!

      visit = restaurant.visits.create!(
        user:       current_user,
        visited_at: Date.current,
      )

      create_audit_log(action: "visit_create", target: restaurant)
    end

    redirect_to restaurant_path(params[:restaurant_hotpepper_id]),
                notice: "訪問済みにしました！"

  rescue ActiveRecord::RecordInvalid
    redirect_to restaurant_path(params[:restaurant_hotpepper_id]),
                alert: "訪問記録の保存に失敗しました"
  end

  def destroy
    restaurant = Restaurant.find_by!(hotpepper_id: params[:restaurant_hotpepper_id])
    visit = current_user.visits.find_by!(restaurant: restaurant)
    visit.destroy

    create_audit_log(action: "visit_destroy", target: restaurant)

    redirect_to restaurant_path(params[:restaurant_hotpepper_id]),
                notice: "訪問済みを解除しました"
  end
end