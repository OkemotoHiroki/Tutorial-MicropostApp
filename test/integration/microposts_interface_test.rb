require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  include ActionDispatch::TestProcess
  def setup
    @user = users(:michael)
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match I18n.t("microposts.count", count: @user.microposts.count), response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match I18n.t("microposts.count", count: 0), response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match I18n.t("microposts.count", count: 1), response.body
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select "ul.pagination"
    assert_select "li.page-item"
    assert_select "a.page-link"
    assert_select "input[type=file]"
    # 無効な送信
    post microposts_path, params: { micropost: { content: "" } }
    assert_select "div#error_explanation"
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload("test/fixtures/rails.png", "image/png")
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost:
                                      { content: content,
                                        picture: picture }, multipart: true }
    end

    @micropost = Micropost.first
    assert @micropost.picture.attached?
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select "a", I18n.t("helpers.links.delete")
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセスする
    get user_path(users(:archer))
    assert_select "a", { text: I18n.t("helpers.links.delete"), count: 0 }
  end
end
