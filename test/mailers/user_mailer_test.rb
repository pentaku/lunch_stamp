require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    body = [mail.text_part&.body&.decoded,
            mail.html_part&.body&.decoded].compact.join

    assert_equal "【Lunch Stamp】アカウント有効化のご案内", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["user@realdomain.com"], mail.from
    assert_match user.name, body
    assert_match user.activation_token, body
    assert_match CGI.escape(user.email), body
  end
end
