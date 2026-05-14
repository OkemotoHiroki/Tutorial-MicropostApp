require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "layout links" do
    get root_path
    assert_response :success
    assert_select "meta[name=?][content=?]", "application-name", I18n.t("app.name")
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    expected_title = "#{I18n.t("static_pages.contact.title")} | #{I18n.t("app.base_title")}"
    assert_select "title", expected_title
  end
end
