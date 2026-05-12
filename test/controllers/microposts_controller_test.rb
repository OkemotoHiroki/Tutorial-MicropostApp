require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference "Micropost.count" do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end

  test "create with valid params creates micropost and redirects" do
    log_in_as(users(:michael))
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost: { content: "Valid content" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "create with invalid params renders home with error" do
    log_in_as(users(:michael))
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "destroy own micropost deletes it and redirects" do
    log_in_as(users(:michael))
    micropost = microposts(:orange)
    assert_difference "Micropost.count", -1 do
      delete micropost_path(micropost)
    end
    assert_not flash.empty?
    assert_response :redirect
  end
end
