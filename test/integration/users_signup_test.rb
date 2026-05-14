require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup infrmation" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_select "div#error_explanation"
  end
  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name:  "Example User",
                                        email: "user@example.com",
                                        password:              "password",
                                        password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = User.find_by(email: "user@example.com")

    mail = ActionMailer::Base.deliveries.last
  token = mail.text_part.body.decoded.match(/\/account_activations\/(.+?)\/edit/)[1]

    # トークン不正
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    # メール不正
    get edit_account_activation_path(token, email: "wrong")
    assert_not is_logged_in?

    # 正常
    get edit_account_activation_path(token, email: user.email)
    assert user.reload.activated?
    follow_redirect!

    assert_response :success
    assert_select "h1", user.name

    assert is_logged_in?
  end
end
