require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get login_path
    assert_response :success
  end

  test "create with valid credentials logs in and redirects" do
    post login_path, params: { session: { email: @user.email, password: "password" } }
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "create with invalid credentials renders new with danger flash" do
    post login_path, params: { session: { email: @user.email, password: "wrong" } }
    assert_not is_logged_in?
    assert_not flash.empty?
    assert_response :unprocessable_entity
  end

  test "create with unactivated user shows warning and redirects to root" do
    unactivated = users(:unactivated_user)
    post login_path, params: { session: { email: unactivated.email, password: "password" } }
    assert_not is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "destroy logs out and redirects to root" do
    log_in_as(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
  end
end
