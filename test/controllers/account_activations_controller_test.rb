require "test_helper"

class AccountActivationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    # サインアップして有効化トークンを取得
    post users_path, params: { user: { name: "New User",
                                       email: "activate_test@example.com",
                                       password: "password",
                                       password_confirmation: "password" } }
    @user = User.find_by(email: "activate_test@example.com")
    mail = ActionMailer::Base.deliveries.last
    @token = mail.body.encoded.match(/\/account_activations\/(.+?)\/edit/)[1]
  end

  test "edit with valid token activates user and logs in" do
    assert_not @user.activated?
    get edit_account_activation_path(@token, email: @user.email)
    assert @user.reload.activated?
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to @user
  end

  test "edit with invalid token does not activate user" do
    get edit_account_activation_path("bad_token", email: @user.email)
    assert_not @user.reload.activated?
    assert_not is_logged_in?
    assert_redirected_to root_url
  end

  test "edit with wrong email does not activate user" do
    get edit_account_activation_path(@token, email: "wrong@example.com")
    assert_not @user.reload.activated?
    assert_redirected_to root_url
  end
end
