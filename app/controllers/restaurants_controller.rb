class RestaurantsController < ApplicationController
  def index
    if params[:keyword].present?
      @restaurants = HotpepperService.search(params[:keyword])
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
