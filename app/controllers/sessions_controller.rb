class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user&.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user
      else
        flash[:warning] = "メールを確認してアカウントを有効化してください"
        redirect_to root_url
      end
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが正しくありません"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
