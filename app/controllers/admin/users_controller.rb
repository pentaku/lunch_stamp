module Admin
  class UsersController < ApplicationController
    before_action :logged_in_user
    before_action :admin_user

    def index
      @users = User.order(created_at: :asc)
    end
  end
end
