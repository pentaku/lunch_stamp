class RestaurantsController < ApplicationController
  def index
    if params[:keyword].present? || params[:genre].present? || params[:budget].present?
      @restaurants = HotpepperService.search(
        keyword: params[:keyword].to_s,
        genre:   params[:genre].to_s,
        budget:  params[:budget].to_s
      )
    else
      @restaurants = []
    end
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
