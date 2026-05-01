class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【Lunch Stamp】アカウント有効化のご案内"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
