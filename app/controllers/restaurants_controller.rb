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
end
