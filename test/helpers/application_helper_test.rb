require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, I18n.t("app.base_title")
    assert_equal full_title(I18n.t("static_pages.help.title")), "#{I18n.t("static_pages.help.title")} | #{I18n.t("app.base_title")}"
  end
end
