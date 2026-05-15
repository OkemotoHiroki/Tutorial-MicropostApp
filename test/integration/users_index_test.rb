require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
  log_in_as(@admin)
  get users_path

  assert_response :success
    assert_select "h1", I18n.t("users.index.title")

    assert_select "ul.pagination"
    assert_select "li.page-item"
    assert_select "a.page-link"
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: I18n.t("helpers.links.delete")
      end
    end
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select "a", text: I18n.t("helpers.links.delete"), count: 0
  end
  test "index only shows activated users" do
    log_in_as(@admin)
    get users_path
    assert_response :success

    assert_select "a[href=?]", user_path(@admin), text: @admin.name

    assert_select "a[href=?]", user_path(users(:unactivated_user)), count: 0
  end
  test "do not show unactivated user profile" do
    unactivated = users(:unactivated_user)

    get user_path(unactivated)
    assert_redirected_to root_url
  end
end
