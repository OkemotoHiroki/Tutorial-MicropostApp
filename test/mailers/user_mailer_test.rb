require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    text_body = mail.text_part.body.decoded
    assert_equal I18n.t("user_mailer.account_activation.subject"), mail.subject
    assert_equal [ user.email ], mail.to
    assert_equal [ "noreply@example.com" ], mail.from
    assert_match user.name,               text_body
    assert_match user.activation_token,   text_body
    assert_match CGI.escape(user.email),  text_body
  end

  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    text_body = mail.text_part.body.decoded
    assert_equal I18n.t("user_mailer.password_reset.subject"), mail.subject
    assert_equal [ user.email ], mail.to
    assert_equal [ "noreply@example.com" ], mail.from
    assert_match user.reset_token,        text_body
    assert_match CGI.escape(user.email),  text_body
  end
end
