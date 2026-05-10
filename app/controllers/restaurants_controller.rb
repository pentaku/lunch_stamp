class RestaurantsController < ApplicationController
  def index
    if params[:keyword].present? || params[:genre].present? || params[:budget].present?
      @restaurants = HotpepperService.search(
        keyword: params[:keyword].to_s,
        genre: params[:genre].to_s,
        budget: params[:budget].to_s
      )
    else
      @restaurants = []
    end
  end

  def show
    @shop = HotpepperService.find(params[:hotpepper_id])
    if @shop.blank?
      redirect_to restaurants_path,
            alert: "店舗情報が取得できませんでした"
    end
  end

  def new
  end

  def edit
  end

  def create
    @restaurant = Restaurant.find_or_initialize_by(
      hotpepper_id: restaurant_params[:hotpepper_id]
    )

    unless @restaurant.new_record?
      return redirect_back_or_to(restaurants_path, notice: "すでに保存済みのお店です")
    end

    @restaurant.assign_attributes(restaurant_params)

    if @restaurant.save
      redirect_back_or_to(restaurants_path, notice: "お店を保存しました！")
    else
      redirect_back_or_to(restaurants_path, alert: "保存に失敗しました")
    end
  end

  def update
  end

  def destroy
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(
      :hotpepper_id,
      :name,
      :address,
      :genre,
      :area,
      :budget,
      :photo_url,
      :url
    )
  end
end
