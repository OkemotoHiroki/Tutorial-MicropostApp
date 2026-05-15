require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_response :success

    assert_select "title", "#{@user.name} | #{I18n.t('app.base_title')}"
    assert_select "h1", text: @user.name
    assert_select "h1>img.gravatar"
    assert_match @user.microposts.count.to_s, response.body
    assert_select "ul.pagination", 1
    assert_select "li.page-item"
    assert_select "a.page-link"
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
